**8.4. (ação já OK) Cloud Functions \- Dependências e Deploy**

1. **package.json:** Certifique-se de que seu functions/package.json possui as dependências necessárias.  
   {  
     "name": "functions",  
     "description": "Cloud Functions for Firebase",  
     "scripts": {  
       "serve": "firebase emulators:start \--only functions",  
       "shell": "firebase functions:shell",  
       "start": "npm run shell",  
       "deploy": "firebase deploy \--only functions",  
       "logs": "firebase functions:log"  
     },  
     "engines": {  
       "node": "18"  
     },  
     "main": "index.js",  
     "dependencies": {  
       "firebase-admin": "^11.8.0",  
       "firebase-functions": "^4.3.1"  
     },  
     "devDependencies": {  
       "firebase-functions-test": "^3.1.0"  
     },  
     "private": true  
   }

2. **index.js:** Exporte a nova função no seu arquivo principal functions/index.js.  
   const admin \= require("firebase-admin");  
   admin.initializeApp();

   const assignmentFunctions \= require('./assignment');  
   exports.autoAssignVolunteers \= assignmentFunctions.autoAssignVolunteers;

   // ... suas outras funções

3. **Deploy:** Execute o comando de deploy no terminal, na raiz do seu projeto Firebase.  
   firebase deploy \--only functions  

--executar via python
python -m http.server 8080 --directory build/web
Serving HTTP on :: port 8080 (http://[::]:8080/) ...

estudar
AutomaticKeepAliveClientMixin