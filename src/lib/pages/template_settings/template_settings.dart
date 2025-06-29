import 'package:flutter/material.dart';
import 'package:invoice/models/template.dart';
import 'package:invoice/pages/template_settings/template_overview.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';
import 'package:invoice/widgets/template_setting_widget.dart';

class TemplateSettingsPage extends StatefulWidget {
  final Template template;
  const TemplateSettingsPage({super.key, required this.template});

  @override
  State<TemplateSettingsPage> createState() => _TemplateSettingsPageState();
}

class _TemplateSettingsPageState extends State<TemplateSettingsPage> {
  int maxTemplateId = 0;

  List<(int, String, String)> getAdditionalFields() {
    List<(int, String, String)> additionalFields = [];
    widget.template.templateData.forEach((csv_key, csv_value) {
      if (csv_key.startsWith("custom__title_")) {
        int id = int.parse(csv_key.split("_").last);
        // Only continue here if value and title are not empty
        if (csv_value.isEmpty &&
            widget.template.templateData["custom__value_$id"]?.isEmpty ==
                true) {
          return; // Skip empty fields
        }
        additionalFields.add((
          id,
          csv_value,
          widget.template.templateData["custom__value_$id"] ?? ""
        ));
        if (id > maxTemplateId) maxTemplateId = id;
      }
    });
    return additionalFields;
  }

  void addAdditionalField() {
    setState(() {
      maxTemplateId++;
      widget.template.templateData["custom__title_$maxTemplateId"] =
          "Zusätzliches";
      widget.template.templateData["custom__value_$maxTemplateId"] = "Feld";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Vorlagen-Einstellungen",
      contentElements: [
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Template-Name",
            defaultValue: "",
            csvKey: "TEMPLATE-NAME"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Firma",
            defaultValue: "Musterfirma",
            csvKey: "SEN-COMPANY"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Ihr Name",
            defaultValue: "Max Mustermann",
            csvKey: "SEN-NAME"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Straße",
            defaultValue: "Musterstraße 12",
            csvKey: "SEN-STREET"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "PLZ",
            defaultValue: "12345",
            csvKey: "SEN-ZIP"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Stadt",
            defaultValue: "Musterstadt",
            csvKey: "SEN-CITY"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Telefon",
            defaultValue: "+49 (0)123 456789",
            csvKey: "SEN-PHONE"),
        TemplateSettingWidgetTextLine(
          template: widget.template,
          description: "E-Mail",
          defaultValue: "",
          csvKey: "SEN-EMAIL",
        ),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Webseite",
            defaultValue: "www.domain.com",
            csvKey: "SEN-WEBSITE"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Bank",
            defaultValue: "DAB-Bank",
            csvKey: "MONEY-INSTITUTE"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "IBAN",
            defaultValue: "DE00 3006 0088 1234 5678 90",
            csvKey: "IBAN"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "BIC",
            defaultValue: "DRTTZZUUXXX",
            csvKey: "BIC"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "USt-IdNr.",
            defaultValue: "DE123456789",
            csvKey: "SEN-TAX-ID"),
        TemplateSettingWidgetTextLine(
          template: widget.template,
          description: "Anrede",
          defaultValue: "Sehr geehrte Damen und Herren,",
          csvKey: "SALUTATION",
        ),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Rechnungstext",
            defaultValue:
                "bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\\invoiceReference) bis zum \\payDate \\ auf das angegebene Konto ein.",
            csvKey: "MESSAGE"),
        TemplateSettingWidgetTextLine(
          template: widget.template,
          description: "Rechnungshinweis",
          defaultValue:
              "Das Leistungsdatum entspricht dem Rechnungsdatum. Der angegebene Preis ist ein Endpreis. Gemäß 19 § UStG erhebe ich keine Umsatzsteuer und weise diese folglich auch nicht aus.",
          csvKey: "HINT",
        ),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Rechnungsabschluss",
            defaultValue: "Mit freundlichen Grüßen",
            csvKey: "CLOSING"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Pfad zum Logo (png)",
            defaultValue: "logo.png",
            information:
                "Logos können entweder einen absoluten Pfad beinhalten oder unter ~/Rechnungen/data/templates abgelegt werden. Im letzteren Fall reicht der Dateiname.",
            csvKey: "ICON-PATH"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Standard Steuersatz (in %)",
            defaultValue: "0",
            csvKey: "DEFAULT-VAT"),
        TemplateSettingWidgetTextLine(
            template: widget.template,
            description: "Währung",
            defaultValue: "€",
            csvKey: "CURRENCY"),

        // Additional fields
        for (var additionalField in getAdditionalFields())
          TemplateSettingWidgetTextLine(
            template: widget.template,
            description: additionalField.$2,
            defaultValue: additionalField.$3,
            csvKey: "${additionalField.$1}",
            additionalField: true,
            information:
                "Um dieses Feld zu löschen lassen Sie beide Felder leer und wählen Sie 'Alles Speichern'.",
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MintYButton(
              text: const Text("Zusätzliches Feld hinzufügen",
                  style: MintY.heading4White),
              onPressed: addAdditionalField,
              color: MintY.currentColor,
            ),
          ],
        ),

        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MintYButtonNavigate(
              route: const TemplateOverviewPage(),
              onPressed: () => TemplateService.deleteTemplate(widget.template),
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
              TemplateService.init();
              ConfigHandler.loadConfigFromFile();
            },
            route: const TemplateOverviewPage(),
          ),
          const SizedBox(width: 20),
          MintYButtonNavigate(
            text: const Text("Alles Speichern", style: MintY.heading4White),
            onPressed: () {
              TemplateService.saveTemplate(widget.template);
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
