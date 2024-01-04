import 'package:flutter/material.dart';
import 'package:invoice/models/template.dart';
import 'package:invoice/pages/template_settings/template_overview.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';
import 'package:invoice/widgets/template_setting_widget.dart';

class TemplateSettingsPage extends StatelessWidget {
  final Template template;
  const TemplateSettingsPage({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Vorlagen-Einstellungen",
      contentElements: [
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Template-Name",
            defaultValue: "",
            csvKey: "TEMPLATE-NAME"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Ihr Name",
            defaultValue: "Max Mustermann",
            csvKey: "SEN-NAME"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Straße",
            defaultValue: "Musterstraße 12",
            csvKey: "SEN-STREET"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "PLZ",
            defaultValue: "12345",
            csvKey: "SEN-ZIP"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Stadt",
            defaultValue: "Musterstadt",
            csvKey: "SEN-CITY"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Telefon",
            defaultValue: "+49 (0)123 456789",
            csvKey: "SEN-PHONE"),
        TemplateSettingWidgetTextLine(
          template: template,
          description: "E-Mail",
          defaultValue: "",
          csvKey: "SEN-EMAIL",
        ),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Webseite",
            defaultValue: "www.domain.com",
            csvKey: "SEN-WEBSITE"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Bank",
            defaultValue: "DAB-Bank",
            csvKey: "MONEY-INSTITUTE"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "IBAN",
            defaultValue: "DE00 3006 0088 1234 5678 90",
            csvKey: "IBAN"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "BIC",
            defaultValue: "DRTTZZUUXXX",
            csvKey: "BIC"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "USt-IdNr.",
            defaultValue: "DE123456789",
            csvKey: "SEN-TAX-ID"),
        TemplateSettingWidgetTextLine(
          template: template,
          description: "Anrede",
          defaultValue: "Sehr geehrte Damen und Herren,",
          csvKey: "SALUTATION",
        ),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Rechnungstext",
            defaultValue:
                "bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\\invoiceReference) bis zum \\payDate \\ auf das angegebene Konto ein.",
            csvKey: "MESSAGE"),
        TemplateSettingWidgetTextLine(
          template: template,
          description: "Rechnungshinweis",
          defaultValue:
              "Das Leistungsdatum entspricht dem Rechnungsdatum. Der angegebene Preis ist ein Endpreis. Gemäß 19 § UStG erhebe ich keine Umsatzsteuer und weise diese folglich auch nicht aus.",
          csvKey: "HINT",
        ),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Rechnungsabschluss",
            defaultValue: "Mit freundlichen Grüßen",
            csvKey: "CLOSING"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Absoluter Pfad zum Logo\n(.png, bis 150px)",
            defaultValue: "/home/benutzer/Bilder/logo.png",
            csvKey: "ICON-PATH"),
        TemplateSettingWidgetTextLine(
            template: template,
            description: "Standard Steuersatz (in %)",
            defaultValue: "0",
            csvKey: "DEFAULT-VAT"),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MintYButtonNavigate(
              route: const TemplateOverviewPage(),
              onPressed: () => TemplateService.deleteTemplate(template),
              text: const Text("Vorlage löschen", style: MintY.heading4White),
              color: Colors.red,
            ),
          ],
        )
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MintYButtonNavigate(
            text: const Text("Zurück", style: MintY.heading4),
            onPressed: () {
              /// Trigger init to reload the settings from file
              /// and destroy temporary settings, which the user could have made
              /// but not saved
              TemplateService.init();
              ConfigHandler.loadConfigFromFile();
            },
            route: const TemplateOverviewPage(),
          ),
          const SizedBox(width: 20),
          MintYButtonNavigate(
            text: const Text("Alles Speichern", style: MintY.heading4White),
            onPressed: () {
              TemplateService.saveTemplate(template);
              ConfigHandler.saveConfigToFile();
            },
            color: MintY.currentColor,
            route: const TemplateOverviewPage(),
          )
        ],
      ),
    );
  }
}
