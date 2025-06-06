# Remote Team Task Board

A full-stack project for managing remote team tasks, featuring a Dart Frog backend and a Flutter frontend.

---

## Architecture Overview

This project is organized into two main parts:

- **Backend:** Located in `remote_team_task_board/`, built with [Dart Frog](https://dartfrog.vgv.dev/) for RESTful APIs and SQLite for data persistence. It follows a modular structure with routes for authentication, workspaces, tasks, columns, and comments.

- **Frontend:** Located in `remote_team_task_board_flutter/`, built with [Flutter](https://flutter.dev/) using the BLoC pattern, clean architecture, and dependency injection via `get_it`. It communicates with the backend via HTTP APIs.

### Backend Structure

- `bin/` — Entry points for the server and database initialization.
- `lib/` — Core business logic and services.
- `routes/` — API endpoints (auth, workspaces, tasks, columns, comments).
- `test/` — Unit and integration tests.

### Frontend Structure

- `lib/` — Main application code, organized by feature (auth, workspace, task, column), with clear separation of data, domain, and presentation layers.
- `test/` — Widget and unit tests.

---

## How to Run Backend

1. **Install Dart SDK:**  
   <https://dart.dev/get-dart>

2. **Install dependencies:**

   ```sh
   cd remote_team_task_board
   dart pub get
   ```

3. **Initialize the database (if needed):**

   ```sh
   dart bin/init_db.dart
   ```

4. **Run the server:**

   ```sh
   dart_frog dev
   ```

   The server will start on `http://localhost:8080` by default.

---

## How to Run Frontend

1. **Install Flutter SDK:**  
   <https://docs.flutter.dev/get-started/install>

2. **Install dependencies:**

   ```sh
   cd remote_team_task_board_flutter
   flutter pub get
   ```

3. **Run the app:**

   - For web:

     ```sh
     flutter run -d chrome
     ```

   - For mobile (iOS/Android):

     ```sh
     flutter run
     ```

4. **Configuration:**
   - The frontend expects the backend to be running at the configured base URL (see `ApiConstants.baseUrl` in the frontend code).

---

## Additional Notes

- The backend uses SQLite for persistence; the database file is `taskboard.db`.
- The frontend uses BLoC for state management and `get_it` for dependency injection (see `lib/core/injection/injection_container.dart`).
- For development, run both backend and frontend locally. For production, configure the base URL and database as needed.

---

## License

MIT License. See `LICENSE` file for details.
