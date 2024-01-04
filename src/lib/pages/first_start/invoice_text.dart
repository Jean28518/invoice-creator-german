import 'package:flutter/material.dart';
import 'package:invoice/pages/first_start/last_hints.dart';
import 'package:invoice/widgets/mint_y.dart';
import 'package:invoice/widgets/setting_widget.dart';
import 'package:invoice/widgets/template_setting_widget.dart';
import 'package:invoice/services/template_service.dart';

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
          Möchtest Du ein Feld nicht benutzen, lösche den Inhalt.""",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        TemplateSettingWidgetTextLine(
          template: TemplateService.currentTemplate,
          description: "Anrede",
          defaultValue: "Sehr geehrte Damen und Herren,",
          csvKey: "SALUTATION",
          displaySaveButton: false,
        ),
        TemplateSettingWidgetTextLine(
          template: TemplateService.currentTemplate,
          description: "Rechnungstext",
          defaultValue:
              "bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\\invoiceReference) bis zum \\payDate \\ auf das angegebene Konto ein.",
          csvKey: "MESSAGE",
          displaySaveButton: false,
        ),
        TemplateSettingWidgetTextLine(
          template: TemplateService.currentTemplate,
          description: "Rechnungshinweis",
          defaultValue:
              "Das Leistungsdatum entspricht dem Rechnungsdatum. Der angegebene Preis ist ein Endpreis. Gemäß 19 § UStG erhebe ich keine Umsatzsteuer und weise diese folglich auch nicht aus.",
          csvKey: "HINT",
          displaySaveButton: false,
        ),
        TemplateSettingWidgetTextLine(
          template: TemplateService.currentTemplate,
          description: "Rechnungsabschluss",
          defaultValue: "Mit freundlichen Grüßen",
          csvKey: "CLOSING",
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
        TemplateSettingWidgetTextLine(
          template: TemplateService.currentTemplate,
          description: "Pfad zum Logo\n(.png, bis 150px)",
          defaultValue: "logo.png",
          csvKey: "ICON-PATH",
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
