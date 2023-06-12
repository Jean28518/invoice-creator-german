import 'package:flutter/material.dart';
import 'package:invoice/widgets/mint_y.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      customContentElement: Center(
        child: Text("Test"),
      ),
    );
  }
}
