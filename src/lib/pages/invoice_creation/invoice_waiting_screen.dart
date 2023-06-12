import 'package:flutter/material.dart';
import 'package:invoice/pages/invoice_creation/invoice_creation.dart';
import 'package:invoice/pages/invoice_creation/test.dart';
import 'package:invoice/pages/template_settings/template_settings.dart';
import 'package:invoice/widgets/mint_y.dart';

class InvoiceCreationWaitingPage extends StatelessWidget {
  final Future<void> creationFunction;

  const InvoiceCreationWaitingPage({super.key, required this.creationFunction});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: creationFunction,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return InvoiceCreationPage();
          } else {
            return const MintYLoadingPage(
              text: "Erstelle Rechnung...",
            );
          }
        });
  }
}
