import 'package:flutter/material.dart';
import 'package:invoice/datatypes/article.dart';
import 'package:invoice/pages/invoice_creation/invoice_creation.dart';
import 'package:invoice/services/article_service.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/customer_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class LoadingScreenPage extends StatelessWidget {
  const LoadingScreenPage({super.key});

  Future<void> loadingFunction() async {
    await ConfigHandler.ensureConfigIsLoaded();
    CustomerService.init();
    ArticleService.init();
  }

  @override
  Widget build(BuildContext context) {
    Future loading = loadingFunction();
    return FutureBuilder(
      future: loading,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return InvoiceCreationPage();
        } else {
          return MintYLoadingPage(
            text: "Lade Daten...",
          );
        }
      },
    );
  }
}
