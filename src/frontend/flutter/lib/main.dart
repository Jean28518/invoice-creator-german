import 'package:flutter/material.dart';
import 'package:invoice/pages/loading_screen.dart';
import 'package:invoice/widgets/mint_y.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MintY.theme(),
      home: const LoadingScreenPage(),
    );
  }
}
