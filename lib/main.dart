import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA34A31),
          primary: const Color(0xFF963F2C),
          surface: const Color(0xFFFFFCF8),
          onSurface: const Color(0xFF29221E),
          onSurfaceVariant: const Color(0xFF635950),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F2EB),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
