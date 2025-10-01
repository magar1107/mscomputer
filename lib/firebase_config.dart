// lib/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyBG8bzmvmDaQg1VK6IBXv8CaPfzLLexyOU",
  authDomain: "mscomputersangola-5089f.firebaseapp.com",
  projectId: "mscomputersangola-5089f",
  storageBucket: "mscomputersangola-5089f.firebasestorage.app",
  messagingSenderId: "633673153075",
  appId: "1:633673153075:web:d7de8f0aaf4d9c37fd0146",
  measurementId: "G-3WMG0R7LNH"
);

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => firebaseConfig;
}
