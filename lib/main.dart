import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/widget_provider.dart';
import 'pages/canvas_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WidgetProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arial'),
      home: const CanvasPage(),
    );
  }
}