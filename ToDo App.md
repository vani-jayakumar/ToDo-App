
## Features

### Firebase Authentication
This app uses **Firebase Authentication** to handle user sign-up and login. Users can create an account using their email and password. The authentication flow is managed using FirebaseAuth, providing a secure way to authenticate users and manage their sessions.

- **Sign Up**: Users can register with an email and password.
- **Login**: Users can log in to their accounts using their credentials.

### Firebase Remote Config
**Firebase Remote Config** is utilized to manage and customize app settings remotely. This feature allows for dynamic changes to UI elements without requiring an app update.

- **Dynamic Updates**: Fetches values from the Firebase console, enabling real-time updates to UI components.

### Firebase Firestore
The app utilizes **Firebase Firestore** to store and retrieve To-Do items associated with each user. Firestore provides a flexible, scalable database solution, enabling real-time synchronization and easy data access.

- **CRUD Operations**: Users can create, read, update, and delete tasks in their To-Do list.
- **Real-time Updates**: The app automatically updates the task list as items are added or removed.
