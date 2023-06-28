import 'package:flutter/material.dart';
import 'package:invoice/datatypes/article.dart';
import 'package:invoice/pages/first_start/first_start.dart';
import 'package:invoice/pages/invoice_creation/invoice_creation.dart';
import 'package:invoice/services/article_service.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/customer_service.dart';
import 'package:invoice/services/template_setting_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class LoadingScreenPage extends StatelessWidget {
  const LoadingScreenPage({super.key});

  /// Returns if the first start of the application is done
  Future<bool> loadingFunction() async {
    await ConfigHandler.ensureConfigIsLoaded();
    TemplateSettingService.init();
    CustomerService.init();
    ArticleService.init();

    return ConfigHandler.getValueUnsafe("first_start_done", false);
  }

  @override
  Widget build(BuildContext context) {
    Future loading = loadingFunction();
    return FutureBuilder(
      future: loading,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == false) {
            return FirstStartPage();
          } else {
            return InvoiceCreationPage();
          }
        } else {
          return MintYLoadingPage(
            text: "Lade Daten...",
          );
        }
      },
    );
  }
}
