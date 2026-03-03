# Memtor Connect

A premium Flutter application for mentorship and professional connections.

## Project Structure

This project follows a clean architecture pattern to ensure maintainability and scalability.

- **`lib/constants`**: App configuration, colors, and strings.
- **`lib/models`**: Data models and JSON serialization.
- **`lib/screens`**: UI pages and screen-specific logic.
- **`lib/services`**: External APIs, database interactions, and business logic.
- **`lib/theme`**: App-wide styling, colors, and typography.
- **`lib/widgets`**: Reusable UI components.
- **`lib/providers`**: Riverpod state management providers.
- **`lib/utils`**: Helper functions and extensions.
- **`assets/`**: Images, fonts, and other static files.

## Getting Started

1.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run the app**:
    ```bash
    flutter run
    ```

## Technologies Used

- **State Management**: [Riverpod](https://riverpod.dev)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Styling**: [Google Fonts](https://pub.dev/packages/google_fonts)
- **Theming**: Material 3
