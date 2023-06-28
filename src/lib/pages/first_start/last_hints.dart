import 'package:flutter/material.dart';
import 'package:invoice/pages/invoice_creation/invoice_creation.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/template_setting_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class LastHintsPage extends StatelessWidget {
  const LastHintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Lasst uns Rechnungen schreiben!",
      contentElements: [
        Text(
          "Fertig!",
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          """Herzlichen Glückwunsch! Du hast die Einrichtung abgeschlossen.
          Alle Daten können in den Einstellungen verändert werden.

          
          Tipp: Du kannst auch den Rechnungs-Assistent in Skripte einbinden: 'rechnungs-assistent --help'
          """,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MintYButtonNavigate(
              onPressed: () {
                TemplateSettingService.saveAllTemplateSettings();
                ConfigHandler.setValueUnsafe("first_start_done", true);
                ConfigHandler.saveConfigToFile();
              },
              route: const InvoiceCreationPage(),
              text: const Text("Erste Rechnung erstellen",
                  style: MintY.heading4White),
              width: 300,
              color: MintY.currentColor,
            ),
          ],
        )
      ],
    );
  }
}
