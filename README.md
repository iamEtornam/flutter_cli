# Flutter Project Generator CLI

A command-line interface tool that creates Flutter projects with a predefined, scalable folder structure. This CLI tool helps you quickly scaffold a new Flutter project with an organized directory structure following best practices.

## Requirements

- Flutter SDK
- Dart SDK >=2.19.0 <4.0.0

### Flutter SDK Installation

1. Download Flutter SDK:
   - Visit [Flutter's official download page](https://flutter.dev/docs/get-started/install)
   - Choose your operating system and download the SDK
   - Extract the downloaded file to a desired location

2. Add Flutter to PATH:
   - **Windows**:
     - Add the full path to `flutter\bin` to your system's PATH variable
     - Open Command Prompt and run `flutter doctor` to verify the installation
   
   - **macOS/Linux**:
     - Add the following to your shell's config file (.bashrc, .zshrc, etc.):
       ```bash
       export PATH="$PATH:[PATH_TO_FLUTTER_SDK]/flutter/bin"
       ```
     - Replace [PATH_TO_FLUTTER_SDK] with your Flutter installation path
     - Run `source ~/.bashrc` or `source ~/.zshrc` to apply changes
     - Verify installation with `flutter doctor`

3. Run Flutter Doctor:
   ```bash
   flutter doctor
   ```
   - Follow any additional instructions to complete the setup
   - Install any missing dependencies indicated by Flutter Doctor

## Installation

1. Make sure you have Flutter installed on your system. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. Install the CLI tool using one of these methods:

   ```bash
   # Using dart pub global activate
   dart pub global activate flutter_cli

   # Or clone and install from source
   git clone https://github.com/iamEtornam/flutter_cli.git
   cd flutter_cli
   dart pub global activate --source path .
   ```

## Compiling to Native Executables

To compile the CLI tool into a native executable for Linux, macOS, and Windows, follow these steps:

1️⃣ Ensure Dart SDK is Installed

You need Dart installed. If you haven't installed it yet, get it from:
🔗 https://dart.dev/get-dart

Check your version:

```bash
dart --version
```

2️⃣ Compile for the Current OS

If you only need an executable for the OS you're working on, use:

```bash
dart compile exe bin/flutter_cli.dart
```

This generates a flutter_cli.exe (Windows) or flutter_cli (Linux/macOS) in the same directory.

3️⃣ Compile for Specific Platforms

To compile for different operating systems, use cross-compilation:

🟢 Compile for Linux (on Linux)
```bash
dart compile exe bin/flutter_cli.dart -o flutter_cli_linux
```

🟣 Compile for macOS (on macOS)
```bash
dart compile exe bin/flutter_cli.dart -o flutter_cli_macos
```

🔵 Compile for Windows (on Windows)
```bash
dart compile exe bin/flutter_cli.dart -o flutter_cli_windows.exe
```

4️⃣ Cross-Compiling

Dart does not support native cross-compilation (e.g., compiling a Windows executable on Linux). However, you can use Docker or a VM to compile for different platforms.

Cross-Compiling for Linux on macOS/Windows (Using Docker):

```bash
docker run --rm -v "$PWD":/app -w /app dart:latest dart compile exe bin/flutter_cli.dart -o flutter_cli_linux
```

For macOS and Windows, you need a Mac and Windows PC (or a macOS runner like a Mac Mini in the cloud).

5️⃣ Verify the Output

Run:

```bash
./flutter_cli_linux   # On Linux
./flutter_cli_macos   # On macOS
flutter_cli_windows.exe  # On Windows
```

## Usage

1. Open your terminal and run:
   ```bash
   flutter_cli
   ```

2. Follow the prompts:
   - Enter your project name
   - Enter your bundle ID (e.g., com.example.app)

3. The CLI will create your project with the following structure:

```
project_name/
├── lib/
│   ├── components/     # Reusable UI components
│   ├── config/         # App configuration files
│   ├── extensions/     # Dart extensions
│   ├── features/       # Feature-specific code
│   ├── models/         # Data models
│   ├── resources/      # Resources and constants
│   ├── routes/         # Navigation/routing
│   ├── services/       # Services and APIs
│   ├── utils/          # Utility functions
│   └── views/          # UI screens/pages
└── assets/
    ├── images/         # Image assets
    └── fonts/          # Font files
```

## Directory Structure Explanation

- **components/**: Reusable UI widgets and components
- **config/**: Application configuration, theme, and environment variables
- **extensions/**: Dart extension methods
- **features/**: Feature-specific code following a modular architecture
- **models/**: Data models and DTOs
- **resources/**: Static resources, strings, and constants
- **routes/**: Navigation routes and route management
- **services/**: API services, local storage, and other services
- **utils/**: Helper functions and utility classes
- **views/**: Main UI screens and pages

## Additional Features

- Automatically creates `_index.dart` files in each lib/ subdirectory for better code organization
- Configures asset paths in pubspec.yaml
- Validates Flutter installation before project creation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.