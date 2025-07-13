import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/elderly/elderly_dashboard.dart';
import 'screens/caregiver/caregiver_dashboard.dart';

void main() {
  runApp(const EaseCartApp());
}

class EaseCartApp extends StatelessWidget {
  const EaseCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EaseCart - Smart Shopping Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/elderly-dashboard': (context) => const ElderlyDashboard(),
        '/caregiver-dashboard': (context) => const CaregiverDashboard(),
      },
    );
  }
}
