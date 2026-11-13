import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

/// Fungsi utama aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Memuat file .env
  await dotenv.load(fileName: 'lib/.env');
  
  runApp(const MyApp());
}

/// Root widget aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderWrapper(
      child: MaterialApp(
        title: 'Profil Mahasiswa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}