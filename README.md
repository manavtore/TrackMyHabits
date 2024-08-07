# habit_tracker

A new Flutter project.

## Getting Started

# Flutter Firebase Project

This project integrates Firebase with a Flutter application, providing guidance on setup, Firebase configuration, and notifications. Follow these instructions to set up and run the application locally.

## Prerequisites

- Install Flutter on your local machine ([Flutter Installation Guide](https://flutter.dev/docs/get-started/install)).
- Have a Firebase account and access to the Firebase Console.
- Use an IDE such as VSCode or Android Studio.

## Setup Instructions

### 1. Clone the Repository

Clone the repository to your local machine:


First, clone the repository to your local machine:

```bash
git clone <repository-url>
cd <repository-directory>
```

This is a Flutter project integrated with Firebase. The following instructions will guide you through the setup and running of the application locally.

### 2. Configure Firebase

#### iOS Configuration

1. **Create a Firebase Project**: Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. **Add an iOS App**: In the Firebase Console, add a new iOS app to your project. Download the `GoogleService-Info.plist` file when prompted.
3. **Add Firebase SDK**: Place the `GoogleService-Info.plist` file into the `ios/Runner` directory of your Flutter project.
4. **Install CocoaPods Dependencies**: Navigate to the `ios` directory and run `pod install` to install CocoaPods dependencies.

#### Android Configuration

1. **Add an Android App**: In the Firebase Console, add a new Android app to your project. Download the `google-services.json` file when prompted.
2. **Add Firebase SDK**: Place the `google-services.json` file into the `android/app` directory of your Flutter project.
3. **Update Build Files**: Update the `android/build.gradle` file to include the Google services classpath and the `android/app/build.gradle` file to apply the Google services plugin.

### 3. Add Flutter Dependencies

Run the following command to fetch all necessary Flutter packages:
```bash
flutter pub get
```

### 4. Configure Firebase in Your App

Refer the official documents for setup.

### 5. Run the Application

To run the application locally, execute:
```bash
flutter run
```


### 6. Common Issues

- **iOS Simulator Issues**: Ensure your Xcode and CocoaPods are up to date.
- **Android Emulator Issues**: Verify your Android SDK and emulator configurations are correct and up to date.

### 7. Additional Setup

- **Firestore Rules**: Configure Firestore rules for testing and development via the Firebase Console under Firestore Database -> Rules.
- **Authentication Providers**: Set up authentication providers in the Firebase Console under Authentication -> Sign-in Method.

### Notifications

For handling notifications, refer to the official documentation:

- **Firebase Docs**: [Firebase Authentication](https://firebase.google.com/docs/auth)
- **Flutter Local Notifications**: [Flutter Local Notifications Package](https://pub.dev/packages/flutter_local_notifications)




# TrackMyHabits
