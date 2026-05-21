# Elite Fleet Manager

AI-powered car rental and fleet management mobile application.

## Features
- 🚗 Car Fleet Browsing with filters
- 🧠 AI Recommendation Engine (Content-based)
- 📅 Smart Booking System
- 🔐 Firebase Authentication (Email/Password & Google)
- 📍 Google Maps Integration (Placeholder)
- 🧾 Booking Management
- 🛠️ Admin Dashboard

## Tech Stack
- **Frontend**: Flutter (Provider for state management)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Design**: Material 3 (Luxury/Premium theme)

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Firebase Account

### Firebase Setup
1. Create a new project in [Firebase Console](https://console.firebase.google.com/).
2. Add an Android app with package name `com.elite.elite_fleet_manager`.
3. Download `google-services.json` and place it in `android/app/`.
4. Add an iOS app with bundle ID `com.elite.eliteFleetManager`.
5. Download `GoogleService-Info.plist` and place it in `ios/Runner/`.
6. Enable **Authentication** (Email/Password and Google).
7. Enable **Cloud Firestore** and create collections: `users`, `cars`, `bookings`, `reviews`.
8. Enable **Firebase Storage**.

### Running the App
```bash
flutter pub get
flutter run
```

## AI Recommendation Logic
The app uses a content-based filtering system. It tracks the user's preferred car categories (based on views/bookings) and prioritizes those categories in the "Recommended for You" section, while also considering high-rated vehicles.

## Clean Architecture
The project follows a modular structure:
- `lib/core`: Global themes, utils, and shared widgets.
- `lib/features`: Feature-based modules (Auth, Cars, Bookings, Profile, Admin).
- `lib/presentation`: Main navigation and layout.

## License
MIT
