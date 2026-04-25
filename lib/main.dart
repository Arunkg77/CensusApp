import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://xmhclankqtztjjpxgque.supabase.co',
  //   anonKey: 'sb_publishable_9zhfvbKW-Av9gH5uYmidcA_Mn-BmhZx',
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Census APP',
      home: const SplashScreen(),
    );
  }
}
