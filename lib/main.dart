import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mscomputersangola/firebase_config.dart';
import 'package:mscomputersangola/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MS Computer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF0A4C80), // MS Blue
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          // English text uses Poppins
          displayLarge: GoogleFonts.poppins(),
          displayMedium: GoogleFonts.poppins(),
          displaySmall: GoogleFonts.poppins(),
          headlineLarge: GoogleFonts.poppins(),
          headlineMedium: GoogleFonts.poppins(),
          headlineSmall: GoogleFonts.poppins(),
          titleLarge: GoogleFonts.poppins(),
          titleMedium: GoogleFonts.poppins(),
          titleSmall: GoogleFonts.poppins(),
          bodyLarge: GoogleFonts.poppins(),
          bodyMedium: GoogleFonts.poppins(),
          bodySmall: GoogleFonts.poppins(),
          labelLarge: GoogleFonts.poppins(),
          labelMedium: GoogleFonts.poppins(),
          labelSmall: GoogleFonts.poppins(),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
