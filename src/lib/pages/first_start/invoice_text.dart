import 'package:flutter/material.dart';
import 'package:invoice/pages/first_start/last_hints.dart';
import 'package:invoice/widgets/mint_y.dart';
import 'package:invoice/widgets/setting_widget.dart';
import 'package:invoice/widgets/template_setting_widget.dart';

class InvoiceTextEnteringPage extends StatelessWidget {
  const InvoiceTextEnteringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Lasst uns Rechnungen schreiben!",
      centerContentElements: false,
      contentElements: [
        Text(
          """Trage bitte die Texte für die Rechnung ein. 
          Diese können ebenfalls später in den Einstellungen verändert werden.
          Möchtest Du ein Feld nicht benutzen, lasse es leer.""",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        TemplateSettingWidgetTextLine(
          description: "Anrede",
          defaultValue: "Sehr geehrte Damen und Herren,",
          latexKey: "invoiceSalutation",
          displaySaveButton: false,
        ),
        TemplateSettingWidgetTextLine(
          description: "Rechnungstext",
          defaultValue:
              "bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\\invoiceReference) bis zum \\payDate \\ auf das angegebene Konto ein.",
          latexKey: "invoiceText",
          displaySaveButton: false,
        ),
        TemplateSettingWidgetTextLine(
          description: "Rechnungshinweis",
          defaultValue:
              "Das Leistungsdatum entspricht dem Rechnungsdatum. Der angegebene Preis ist ein Endpreis. Gemäß 19 § UStG erhebe ich keine Umsatzsteuer und weise diese folglich auch nicht aus.",
          latexKey: "invoiceHint",
          displaySaveButton: false,
        ),
        TemplateSettingWidgetTextLine(
          description: "Rechnungsabschluss",
          defaultValue: "Mit freundlichen Grüßen",
          latexKey: "invoiceClosing",
          displaySaveButton: false,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          """Zum Ende kannst Du bei Bedarf auch ein Logo-Pfad hinzufügen. 
          Die Grafik sollte im PNG-Format vorliegen und eine Größe von ca. 150x150 Pixel haben.""",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        SettingWidgetTextLine(
          description: "Absoluter Pfad zum Logo\n(.png, bis 150px)",
          defaultValue: "/home/benutzer/Bilder/logo.png",
          configKey: "logoPath",
          displaySaveButton: false,
        ),
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MintYButtonNavigate(
            route: const LastHintsPage(),
            text: const Text("Weiter", style: MintY.heading4White),
            color: MintY.currentColor,
          ),
        ],
      ),
    );
  }
}
