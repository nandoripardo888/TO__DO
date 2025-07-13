import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de dados para representar um usuário no sistema
/// Baseado na estrutura definida no SPEC_GERAL.md
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de UserModel a partir de um Map (JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de UserModel a partir de um DocumentSnapshot do Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para Map sem o ID (usado para criar documentos no Firestore)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id'); // Remove o ID pois será gerado pelo Firestore
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  UserModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Valida se os dados do usuário são válidos
  bool isValid() {
    return id.isNotEmpty &&
        name.isNotEmpty &&
        email.isNotEmpty &&
        _isValidEmail(email);
  }

  /// Valida se o email tem formato válido
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Retorna as iniciais do nome do usuário
  String get initials {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }

  /// Retorna o primeiro nome do usuário
  String get firstName {
    if (name.isEmpty) return '';
    return name.split(' ')[0];
  }

  /// Retorna o nome completo formatado
  String get displayName {
    return name.trim();
  }

  /// Verifica se o usuário tem foto de perfil
  bool get hasPhoto {
    return photoUrl != null && photoUrl!.isNotEmpty;
  }

  /// Retorna a URL da foto ou null se não houver
  String? get profileImageUrl {
    return hasPhoto ? photoUrl : null;
  }

  /// Factory para criar um usuário a partir dos dados do Google Sign-In
  factory UserModel.fromGoogleSignIn({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Factory para criar um usuário a partir do cadastro manual
  factory UserModel.fromRegistration({
    required String uid,
    required String name,
    required String email,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      name: name,
      email: email,
      photoUrl: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Converte para string para debug
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  /// Implementa igualdade baseada no ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  /// Implementa hashCode baseado no ID
  @override
  int get hashCode => id.hashCode;

  /// Método para validar dados antes de salvar
  List<String> validate() {
    final errors = <String>[];

    if (id.isEmpty) {
      errors.add('ID é obrigatório');
    }

    if (name.isEmpty) {
      errors.add('Nome é obrigatório');
    } else if (name.length < 2) {
      errors.add('Nome deve ter pelo menos 2 caracteres');
    } else if (name.length > 50) {
      errors.add('Nome deve ter no máximo 50 caracteres');
    }

    if (email.isEmpty) {
      errors.add('E-mail é obrigatório');
    } else if (!_isValidEmail(email)) {
      errors.add('E-mail inválido');
    }

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      final uri = Uri.tryParse(photoUrl!);
      if (uri == null || !uri.hasAbsolutePath) {
        errors.add('URL da foto inválida');
      }
    }

    return errors;
  }

  /// Verifica se o usuário foi criado recentemente (últimas 24 horas)
  bool get isNewUser {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  /// Retorna há quanto tempo o usuário foi criado
  String get createdTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  /// Retorna há quanto tempo o usuário foi atualizado
  String get updatedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }
}
