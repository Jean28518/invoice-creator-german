import 'package:flutter/material.dart';
import 'package:invoice/pages/first_start/invoice_text.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';
import 'package:invoice/widgets/template_setting_widget.dart';

class BasicDataEnteringPage extends StatelessWidget {
  const BasicDataEnteringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Lasst uns Rechnungen schreiben!",
      centerContentElements: false,
      contentElements: [
        Text(
          """Trage bitte Die Daten zu Deinem Unternehmen ein. 
          Die Daten können später in den Einstellungen verändert werden.
          Kundendaten werden zu einem späteren Zeitpunkt definiert.
          Möchtest Du ein Feld nicht benutzen, lösche den Inhalt.""",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "Name",
            defaultValue: "Max Mustermann",
            csvKey: "SEN-NAME",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "Straße",
            defaultValue: "Musterstraße 12",
            csvKey: "SEN-STREET",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "PLZ",
            defaultValue: "12345",
            csvKey: "SEN-ZIP",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "Stadt",
            defaultValue: "Musterstadt",
            csvKey: "SEN-CITY",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "Telefon",
            defaultValue: "+49 (0)123 456789",
            csvKey: "SEN-PHONE",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "E-Mail",
            defaultValue: "",
            csvKey: "SEN-EMAIL",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "Webseite",
            defaultValue: "www.domain.com",
            csvKey: "SEN-WEBSITE",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "Bank",
            defaultValue: "DAB-Bank",
            csvKey: "MONEY-INSTITUTE",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "IBAN",
            defaultValue: "DE00 3006 0088 1234 5678 90",
            csvKey: "IBAN",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "BIC",
            defaultValue: "DRTTZZUUXXX",
            csvKey: "BIC",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "USt-IdNr.",
            defaultValue: "DE123456789",
            csvKey: "SEN-TAX-ID",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            template: TemplateService.currentTemplate,
            description: "Steuersatz (in Prozent)",
            defaultValue: "19",
            csvKey: "DEFAULT-VAT",
            displaySaveButton: false),
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MintYButtonNavigate(
            route: const InvoiceTextEnteringPage(),
            text: const Text("Weiter", style: MintY.heading4White),
            color: MintY.currentColor,
          ),
        ],
      ),
    );
  }
}
