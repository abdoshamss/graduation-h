import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:garduation_h/auth/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check Hive cache for user session
    final userBox = Hive.box('favorites');
    final session = userBox.get('user_session');
    final bool isLoggedIn = session != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MyHomePage() : const LoginScreen(),
    );
  }
}
