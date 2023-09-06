import 'package:flutter/material.dart';
import 'package:invoice/pages/first_start/invoice_text.dart';
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
            description: "Name",
            defaultValue: "Max Mustermann",
            csvKey: "senderName",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Straße",
            defaultValue: "Musterstraße 12",
            csvKey: "senderStreet",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "PLZ",
            defaultValue: "12345",
            csvKey: "senderZIP",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Stadt",
            defaultValue: "Musterstadt",
            csvKey: "senderCity",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Telefon",
            defaultValue: "+49 (0)123 456789",
            csvKey: "senderTelephone",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Mobil",
            defaultValue: "+49 (0)123 456789",
            csvKey: "senderMobilephone",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "E-Mail",
            defaultValue: "",
            csvKey: "senderEmail",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Webseite",
            defaultValue: "www.domain.com",
            csvKey: "senderWeb",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Bank",
            defaultValue: "DAB-Bank",
            csvKey: "accountBankName",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "IBAN",
            defaultValue: "DE00 3006 0088 1234 5678 90",
            csvKey: "accountIBAN",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "BIC",
            defaultValue: "DRTTZZUUXXX",
            csvKey: "accountBIC",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "USt-IdNr.",
            defaultValue: "DE123456789",
            csvKey: "taxID",
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
