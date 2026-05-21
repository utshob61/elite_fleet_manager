import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/cars/presentation/providers/car_provider.dart';
import 'features/bookings/presentation/providers/booking_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'presentation/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
  } catch (e) {
    debugPrint("Firebase initialization skipped or failed: $e");
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: EliteFleetApp(isFirebaseReady: firebaseInitialized),
    ),
  );
}

class EliteFleetApp extends StatelessWidget {
  final bool isFirebaseReady;
  const EliteFleetApp({super.key, this.isFirebaseReady = false});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Elite Fleet Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuth) {
            return const MainScreen();
          }
          return const LoginPage();
        },
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
