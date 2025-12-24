import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'core/constants.dart';
import 'providers/course_provider.dart';
import 'providers/task_provider.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/notification_service.dart';

/// Entry point of the application.
/// Initializes Flutter bindings, Firebase, and notification service before running the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // Initialize Firebase

  // Initialize Notifications
  await NotificationService().init();

  runApp(MyApp());
}

/// Root widget of the application.
/// Configures providers, screen utilities, and theme for the entire app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Builds the main app widget with MultiProvider setup and theme configuration.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      // Initialize ScreenUtil here
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // The design size from your Figma/Design (Standard iPhone size)
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Student Planner',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: Colors.white,
              textTheme: GoogleFonts.poppinsTextTheme(),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            // Use the child passed by the builder or the screen directly
            home: OnboardingScreen(),
          );
        },
      ),
    );
  }
}