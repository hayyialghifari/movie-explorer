
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MovieExplorerApp());
}

class MovieExplorerApp extends StatelessWidget {
  const MovieExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF10121A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF10121A),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1C1F2A),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
