const {onCall} = require("firebase-functions/v2/https");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const {logger} = require("firebase-functions");

// Inicializar Firebase Admin
admin.initializeApp();
const db = admin.firestore();

/**
 * Função para atualizar status de uma MicroTask
 * Callable function que pode ser chamada diretamente do app
 */
exports.updateMicrotaskStatus = onCall(async (request) => {
  try {
    const {microtaskId, newStatus, userId} = request.data;

    // Validar parâmetros
    if (!microtaskId || !newStatus || !userId) {
      throw new Error("Parâmetros obrigatórios: microtaskId, newStatus, userId");
    }

    // Validar status permitidos
    const validStatuses = ["assigned", "in_progress", "completed"];
    if (!validStatuses.includes(newStatus)) {
      throw new Error(`Status inválido: ${newStatus}`);
    }

    // Log detalhado dos parâmetros recebidos
    logger.info(`[updateMicrotaskStatus] Parâmetros recebidos:`, {
      userId,
      microtaskId,
      newStatus,
      validStatuses,
    });

    // Buscar a user_microtask
    logger.info(`[updateMicrotaskStatus] Buscando user_microtask:`, {
      collection: "user_microtasks",
      microtask_id: microtaskId,
      user_id: userId,
    });

    const userMicrotaskQuery = await db.collection("user_microtasks")
        .where("microtaskId", "==", microtaskId)
        .where("userId", "==", userId)
        .limit(1)
        .get();

    logger.info(`[updateMicrotaskStatus] Resultado da busca:`, {
      empty: userMicrotaskQuery.empty,
      size: userMicrotaskQuery.size,
      docs: userMicrotaskQuery.docs.map((doc) => ({
        id: doc.id,
        data: doc.data(),
      })),
    });

    if (userMicrotaskQuery.empty) {
      // Buscar todos os documentos para debug
      const allUserMicrotasks = await db.collection("user_microtasks")
          .where("microtaskId", "==", microtaskId)
          .get();
      logger.error(`[updateMicrotaskStatus] Debug - Todos os user_microtasks para microtaskId ${microtaskId}:`, {
        total: allUserMicrotasks.size,
        docs: allUserMicrotasks.docs.map((doc) => ({
          id: doc.id,
          userId: doc.data().userId,
          microtaskId: doc.data().microtaskId,
          status: doc.data().status,
        })),
      });
      throw new Error(`User microtask não encontrada para userId: ${userId}, microtaskId: ${microtaskId}`);
    }

    const userMicrotaskDoc = userMicrotaskQuery.docs[0];
    const currentStatus = userMicrotaskDoc.data().status;

    // Validar progressão de status (não permitir regressão)
    const statusOrder = {"assigned": 0, "in_progress": 1, "completed": 2};
    if (statusOrder[newStatus] < statusOrder[currentStatus]) {
      throw new Error(`Regressão de status não permitida: ${currentStatus} -> ${newStatus}`);
    }

    // Atualizar user_microtask
    await userMicrotaskDoc.ref.update({
      status: newStatus,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Status da user_microtask atualizado: ${microtaskId} -> ${newStatus}`);

    return {
      success: true,
      message: "Status atualizado com sucesso",
      microtaskId,
      newStatus,
    };
  } catch (error) {
    logger.error("Erro ao atualizar status da microtask:", error);
    throw new Error(error.message);
  }
});

/**
 * Função para atualizar status de uma Task
 * Callable function que pode ser chamada diretamente do app
 */
exports.updateTaskStatus = onCall(async (request) => {
  try {
    const {taskId, newStatus} = request.data;

    // Validar parâmetros
    if (!taskId || !newStatus) {
      throw new Error("Parâmetros obrigatórios: taskId, newStatus");
    }

    // Validar status permitidos
    const validStatuses = ["pending", "in_progress", "completed"];
    if (!validStatuses.includes(newStatus)) {
      throw new Error(`Status inválido: ${newStatus}`);
    }

    // Buscar a task
    const taskDoc = await db.collection("tasks").doc(taskId).get();
    if (!taskDoc.exists) {
      throw new Error("Task não encontrada");
    }

    const currentStatus = taskDoc.data().status;

    // Validar progressão de status (não permitir regressão)
    const statusOrder = {"pending": 0, "in_progress": 1, "completed": 2};
    if (statusOrder[newStatus] < statusOrder[currentStatus]) {
      throw new Error(`Regressão de status não permitida: ${currentStatus} -> ${newStatus}`);
    }

    // Atualizar task
    await taskDoc.ref.update({
      status: newStatus,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Status da task atualizado: ${taskId} -> ${newStatus}`);

    return {
      success: true,
      message: "Status da task atualizado com sucesso",
      taskId,
      newStatus,
    };
  } catch (error) {
    logger.error("Erro ao atualizar status da task:", error);
    throw new Error(error.message);
  }
});

/**
 * Trigger automático para propagação de status quando user_microtask é atualizada
 * Atualiza automaticamente o status da microtask e task pai quando necessário
 */
exports.onUserMicrotaskStatusChange = onDocumentUpdated(
    "user_microtasks/{docId}",
    async (event) => {
      try {
        const beforeData = event.data.before.data();
        const afterData = event.data.after.data();

        // Verificar se o status mudou
        if (beforeData.status === afterData.status) {
          return;
        }

        const microtaskId = afterData.microtaskId;
        logger.info(`Propagando mudança de status para microtask: ${microtaskId}`);

        // Buscar todas as user_microtasks desta microtask
        const userMicrotasksSnapshot = await db.collection("user_microtasks")
            .where("microtaskId", "==", microtaskId)
            .get();

        if (userMicrotasksSnapshot.empty) {
          logger.warn(`Nenhuma user_microtask encontrada para microtask: ${microtaskId}`);
          return;
        }

        // Calcular novo status da microtask baseado nos status dos voluntários
        const userStatuses = userMicrotasksSnapshot.docs.map((doc) => doc.data().status);
        let newMicrotaskStatus = "assigned";

        // Se pelo menos um voluntário iniciou, microtask fica "in_progress"
        if (userStatuses.some((status) => status === "in_progress" || status === "completed")) {
          newMicrotaskStatus = "in_progress";
        }

        // Se todos os voluntários completaram, microtask fica "completed"
        if (userStatuses.every((status) => status === "completed")) {
          newMicrotaskStatus = "completed";
        }

        // Atualizar status da microtask
        const microtaskRef = db.collection("microtasks").doc(microtaskId);
        const microtaskDoc = await microtaskRef.get();

        if (microtaskDoc.exists) {
          const currentMicrotaskStatus = microtaskDoc.data().status;
          if (currentMicrotaskStatus !== newMicrotaskStatus) {
            await microtaskRef.update({
              status: newMicrotaskStatus,
              updated_at: admin.firestore.FieldValue.serverTimestamp(),
            });
            logger.info(`Status da microtask atualizado: ${microtaskId} -> ${newMicrotaskStatus}`);

            // Propagar para a task pai
            await propagateToParentTask(microtaskDoc.data().taskId);
          }
        }
      } catch (error) {
        logger.error("Erro na propagação de status:", error);
      }
    },
);

/**
 * Função para propagar status para a task pai quando uma microtask é atualizada
 * @param {string} taskId ID da task pai
 */
async function propagateToParentTask(taskId) {
  try {
    // Buscar todas as microtasks desta task
    const microtasksSnapshot = await db.collection("microtasks")
        .where("taskId", "==", taskId)
        .get();

    if (microtasksSnapshot.empty) {
      logger.warn(`Nenhuma microtask encontrada para task: ${taskId}`);
      return;
    }

    // Calcular novo status da task baseado nos status das microtasks
    const microtaskStatuses = microtasksSnapshot.docs.map((doc) => doc.data().status);
    let newTaskStatus = "pending";

    // Se pelo menos uma microtask iniciou, task fica "in_progress"
    if (microtaskStatuses.some((status) => status === "in_progress" || status === "completed")) {
      newTaskStatus = "in_progress";
    }

    // Se todas as microtasks foram completadas, task fica "completed"
    if (microtaskStatuses.every((status) => status === "completed")) {
      newTaskStatus = "completed";
    }

    // Atualizar status da task
    const taskRef = db.collection("tasks").doc(taskId);
    const taskDoc = await taskRef.get();

    if (taskDoc.exists) {
      const currentTaskStatus = taskDoc.data().status;
      if (currentTaskStatus !== newTaskStatus) {
        await taskRef.update({
          status: newTaskStatus,
          updated_at: admin.firestore.FieldValue.serverTimestamp(),
        });
        logger.info(`Status da task atualizado: ${taskId} -> ${newTaskStatus}`);
      }
    }
  } catch (error) {
    logger.error("Erro ao propagar status para task pai:", error);
  }
}

/**
 * Função para obter estatísticas de uma task
 * Retorna contadores de microtasks por status
 */
exports.getTaskStatistics = onCall(async (request) => {
  try {
    const {taskId} = request.data;

    if (!taskId) {
      throw new Error("Parâmetro obrigatório: taskId");
    }

    // Buscar todas as microtasks desta task
    const microtasksSnapshot = await db.collection("microtasks")
        .where("taskId", "==", taskId)
        .get();

    const statistics = {
      total: microtasksSnapshot.size,
      pending: 0,
      assigned: 0,
      in_progress: 0,
      completed: 0,
    };

    microtasksSnapshot.docs.forEach((doc) => {
      const status = doc.data().status || "pending";
      if (Object.prototype.hasOwnProperty.call(statistics, status)) {
        statistics[status]++;
      }
    });

    return {
      success: true,
      taskId,
      statistics,
    };
  } catch (error) {
    logger.error("Erro ao obter estatísticas da task:", error);
    throw new Error(error.message);
  }
});

/**
 * Função para atribuição automática de voluntários
 * Implementa a lógica de heurística e score de compatibilidade
 * conforme especificado no PRD_ATRUIBUICAO_VOLUNTARIO_AUTOMATICA.md
 */
exports.autoAssignVolunteers = onCall(async (request) => {
  try {
    const {eventId, taskId} = request.data;
    const userId = request.auth && request.auth.uid;

    // Validar autenticação
    if (!userId) {
      throw new Error("Usuário não autenticado");
    }

    // Validar parâmetros obrigatórios
    if (!eventId || !taskId) {
      throw new Error("Parâmetros obrigatórios: eventId, taskId");
    }

    logger.info(`[autoAssignVolunteers] Iniciando atribuição automática`, {
      eventId,
      taskId,
      userId,
    });

    // Verificar se o usuário é gerente da campanha
    const eventDoc = await db.collection("events").doc(eventId).get();
    if (!eventDoc.exists) {
      throw new Error("Campanha não encontrada");
    }

    const eventData = eventDoc.data();
    const isManager = eventData.managers && eventData.managers.includes(userId);
    if (!isManager) {
      throw new Error("Apenas gerentes podem executar atribuição automática");
    }

    // Buscar task para validação
    const taskDoc = await db.collection("tasks").doc(taskId).get();
    if (!taskDoc.exists) {
      throw new Error("Task não encontrada");
    }

    const taskData = taskDoc.data();
    if (taskData.eventId !== eventId) {
      throw new Error("Task não pertence à campanha especificada");
    }

    // Buscar microtasks pendentes da task
    const microtasksSnapshot = await db.collection("microtasks")
        .where("taskId", "==", taskId)
        .where("status", "==", "pending")
        .get();

    if (microtasksSnapshot.empty) {
      return {
        success: true,
        message: "Nenhuma microtask pendente encontrada",
        assignedCount: 0,
      };
    }

    // Buscar voluntários da campanha
    const volunteersSnapshot = await db.collection("volunteer_profiles")
        .where("eventId", "==", eventId)
        .get();

    if (volunteersSnapshot.empty) {
      throw new Error("Nenhum voluntário encontrado na campanha");
    }

    // Buscar atribuições existentes para calcular carga de trabalho
    const userMicrotasksSnapshot = await db.collection("user_microtasks")
        .where("eventId", "==", eventId)
        .where("status", "in", ["assigned", "in_progress"])
        .get();

    // Mapear carga de trabalho atual dos voluntários
    const volunteerWorkload = {};
    userMicrotasksSnapshot.docs.forEach((doc) => {
      const data = doc.data();
      const volunteerId = data.userId;
      volunteerWorkload[volunteerId] = (volunteerWorkload[volunteerId] || 0) + 1;
    });

    const batch = db.batch();
    let assignedCount = 0;
    const assignments = [];

    // Processar cada microtask
    for (const microtaskDoc of microtasksSnapshot.docs) {
      const microtask = microtaskDoc.data();
      const microtaskId = microtaskDoc.id;

      logger.info(`[autoAssignVolunteers] Processando microtask: ${microtaskId}`);

      // Calcular scores de compatibilidade para cada voluntário
      const volunteerScores = [];

      for (const volunteerDoc of volunteersSnapshot.docs) {
        const volunteer = volunteerDoc.data();
        const volunteerId = volunteer.userId;

        // Verificar se já está atribuído a esta microtask
        if (microtask.assignedTo && microtask.assignedTo.includes(volunteerId)) {
          continue;
        }

        // Verificar disponibilidade de agenda (conflito de horário)
        const hasTimeConflict = await checkTimeConflict(
            volunteerId,
            microtask.startDateTime,
            microtask.endDateTime,
        );

        if (hasTimeConflict) {
          logger.info(`[autoAssignVolunteers] Voluntário ${volunteerId} tem conflito de horário`);
          continue;
        }

        // Verificar disponibilidade de dias e horários
        const isAvailable = checkAvailability(volunteer, microtask);
        if (!isAvailable) {
          logger.info(`[autoAssignVolunteers] Voluntário ${volunteerId} não está disponível`);
          continue;
        }

        // Calcular score de compatibilidade
        const score = calculateCompatibilityScore(
            volunteer,
            microtask,
            volunteerWorkload[volunteerId] || 0,
        );

        volunteerScores.push({
          volunteerId,
          volunteer,
          score,
        });
      }

      // Ordenar por score (maior primeiro)
      volunteerScores.sort((a, b) => b.score - a.score);

      // Atribuir aos melhores voluntários até atingir maxVolunteers
      const maxVolunteers = microtask.maxVolunteers || 1;
      const selectedVolunteers = volunteerScores.slice(0, maxVolunteers);

      if (selectedVolunteers.length === 0) {
        logger.warn(`[autoAssignVolunteers] Nenhum voluntário disponível para microtask: ${microtaskId}`);
        continue;
      }

      // Atualizar microtask com voluntários atribuídos
      const assignedVolunteerIds = selectedVolunteers.map((v) => v.volunteerId);
      const microtaskRef = db.collection("microtasks").doc(microtaskId);
      batch.update(microtaskRef, {
        assignedTo: assignedVolunteerIds,
        status: "assigned",
        assignedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Criar documentos user_microtasks
      for (const selected of selectedVolunteers) {
        const userMicrotaskRef = db.collection("user_microtasks").doc();
        batch.set(userMicrotaskRef, {
          userId: selected.volunteerId,
          microtaskId: microtaskId,
          taskId: taskId,
          eventId: eventId,
          status: "assigned",
          assignedAt: admin.firestore.FieldValue.serverTimestamp(),
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Atualizar contador de carga de trabalho
        volunteerWorkload[selected.volunteerId] = (volunteerWorkload[selected.volunteerId] || 0) + 1;
      }

      assignments.push({
        microtaskId,
        microtaskTitle: microtask.title,
        assignedVolunteers: selectedVolunteers.map((v) => ({
          id: v.volunteerId,
          name: v.volunteer.userName,
          score: v.score,
        })),
      });

      assignedCount++;
    }

    // Executar todas as operações atomicamente
    if (assignedCount > 0) {
      await batch.commit();
      logger.info(`[autoAssignVolunteers] Atribuição concluída: ${assignedCount} microtasks`);
    }

    return {
      success: true,
      message: `Atribuição automática concluída com sucesso`,
      assignedCount,
      assignments,
    };
  } catch (error) {
    logger.error("[autoAssignVolunteers] Erro na atribuição automática:", error);
    throw new Error(error.message);
  }
});

/**
 * Verifica se há conflito de horário para um voluntário
 * @param {string} volunteerId ID do voluntário
 * @param {Timestamp} startDateTime Data/hora de início da microtask
 * @param {Timestamp} endDateTime Data/hora de fim da microtask
 * @return {boolean} true se há conflito
 */
async function checkTimeConflict(volunteerId, startDateTime, endDateTime) {
  if (!startDateTime || !endDateTime) {
    return false; // Sem horário definido, sem conflito
  }

  try {
    // Buscar microtasks já atribuídas ao voluntário no mesmo período
    const conflictingMicrotasks = await db.collection("user_microtasks")
        .where("userId", "==", volunteerId)
        .where("status", "in", ["assigned", "in_progress"])
        .get();

    for (const doc of conflictingMicrotasks.docs) {
      const userMicrotask = doc.data();
      // Buscar dados da microtask para verificar horários
      const microtaskDoc = await db.collection("microtasks")
          .doc(userMicrotask.microtaskId)
          .get();
      if (!microtaskDoc.exists) continue;
      const microtask = microtaskDoc.data();
      if (!microtask.startDateTime || !microtask.endDateTime) continue;
      // Verificar sobreposição de horários
      const existingStart = microtask.startDateTime.toDate();
      const existingEnd = microtask.endDateTime.toDate();
      const newStart = startDateTime.toDate();
      const newEnd = endDateTime.toDate();
      if (newStart < existingEnd && newEnd > existingStart) {
        return true; // Há conflito
      }
    }
    return false;
  } catch (error) {
    logger.error("Erro ao verificar conflito de horário:", error);
    return true; // Em caso de erro, assumir conflito por segurança
  }
}

/**
 * Verifica disponibilidade do voluntário para a microtask
 * @param {Object} volunteer Dados do voluntário
 * @param {Object} microtask Dados da microtask
 * @return {boolean} true se disponível
 */
function checkAvailability(volunteer, microtask) {
  // Se o voluntário tem disponibilidade integral, está sempre disponível
  if (volunteer.isFullTimeAvailable) {
    return true;
  }

  // Verificar disponibilidade de dias
  if (microtask.startDateTime) {
    const microtaskDate = microtask.startDateTime.toDate();
    const dayOfWeek = microtaskDate.toLocaleDateString("pt-BR", {weekday: "long"});
    if (!volunteer.availableDays.includes(dayOfWeek)) {
      return false;
    }
  }

  // Verificar disponibilidade de horários
  if (microtask.startDateTime && volunteer.availableHours) {
    const microtaskTime = microtask.startDateTime.toDate();
    const timeString = microtaskTime.toTimeString().substring(0, 5); // HH:MM
    const availableStart = volunteer.availableHours.start;
    const availableEnd = volunteer.availableHours.end;
    if (timeString < availableStart || timeString > availableEnd) {
      return false;
    }
  }

  return true;
}

/**
 * Calcula o score de compatibilidade entre voluntário e microtask
 * @param {Object} volunteer Dados do voluntário
 * @param {Object} microtask Dados da microtask
 * @param {number} currentWorkload Carga de trabalho atual do voluntário
 * @return {number} Score de compatibilidade (0-100)
 */
function calculateCompatibilityScore(volunteer, microtask, currentWorkload) {
  let score = 0;

  // Score base por habilidades (40% do score total)
  const requiredSkills = microtask.requiredSkills || [];
  const volunteerSkills = volunteer.skills || [];
  if (requiredSkills.length > 0) {
    const matchingSkills = requiredSkills.filter((skill) =>
      volunteerSkills.includes(skill),
    ).length;
    const skillScore = (matchingSkills / requiredSkills.length) * 40;
    score += skillScore;
  } else {
    score += 20; // Score base se não há habilidades específicas
  }

  // Score por recursos (30% do score total)
  const requiredResources = microtask.requiredResources || [];
  const volunteerResources = volunteer.resources || [];
  if (requiredResources.length > 0) {
    const matchingResources = requiredResources.filter((resource) =>
      volunteerResources.includes(resource),
    ).length;
    const resourceScore = (matchingResources / requiredResources.length) * 30;
    score += resourceScore;
  } else {
    score += 15; // Score base se não há recursos específicos
  }

  // Penalidade por carga de trabalho (30% do score total)
  // Quanto maior a carga, menor o score
  const maxWorkloadPenalty = 30;
  const workloadPenalty = Math.min(currentWorkload * 5, maxWorkloadPenalty);
  score += (maxWorkloadPenalty - workloadPenalty);

  // Bonus por disponibilidade integral
  if (volunteer.isFullTimeAvailable) {
    score += 10;
  }

  return Math.round(Math.max(0, Math.min(100, score)));
}
