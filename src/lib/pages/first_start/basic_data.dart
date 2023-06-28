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
          Möchtest Du ein Feld nicht benutzen, lasse es leer.""",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        TemplateSettingWidgetTextLine(
            description: "Name",
            defaultValue: "Max Mustermann",
            latexKey: "senderName",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Straße",
            defaultValue: "Musterstraße 12",
            latexKey: "senderStreet",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "PLZ",
            defaultValue: "12345",
            latexKey: "senderZIP",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Stadt",
            defaultValue: "Musterstadt",
            latexKey: "senderCity",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Telefon",
            defaultValue: "+49 (0)123 456789",
            latexKey: "senderTelephone",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Mobil",
            defaultValue: "+49 (0)123 456789",
            latexKey: "senderMobilephone",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "E-Mail",
            defaultValue: "",
            latexKey: "senderEmail",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Webseite",
            defaultValue: "www.domain.com",
            latexKey: "senderWeb",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "Bank",
            defaultValue: "DAB-Bank",
            latexKey: "accountBankName",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "IBAN",
            defaultValue: "DE00 3006 0088 1234 5678 90",
            latexKey: "accountIBAN",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "BIC",
            defaultValue: "DRTTZZUUXXX",
            latexKey: "accountBIC",
            displaySaveButton: false),
        TemplateSettingWidgetTextLine(
            description: "USt-IdNr.",
            defaultValue: "DE123456789",
            latexKey: "taxID",
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
