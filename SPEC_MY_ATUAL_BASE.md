┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  Controllers (AuthController, EventController, TaskController)│
│  ↓ (depend on repositories only)                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  Repositories (coordinate between services)                │
│  ↓ (delegate to services)                                  │
│  Services (direct database/Firebase operations)            │
│  ↓ (use models for data structure)                         │
│  Models (pure data classes with validation & business logic)│
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                   EXTERNAL LAYER                           │
├─────────────────────────────────────────────────────────────┤
│  Firebase Firestore, Firebase Auth, External APIs          │
└─────────────────────────────────────────────────────────────┘

