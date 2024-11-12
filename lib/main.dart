import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:me_money_app/auth/login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:me_money_app/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  await Supabase.initialize(
    url: 'https://muvvrtnzbbfpejzhofhs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dnZydG56YmJmcGVqemhvZmhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjE1ODgxMTgsImV4cCI6MjAzNzE2NDExOH0.LNK7P1P0x5AfOWTVOS43YTL-Pvmk3fxXc_9jXbtX7x8',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthRedirect(),
    );
  }
}

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  Future<bool> _checkAuth() async {
    final session = supabase.auth.currentSession;
    return session != null;
  }
}
