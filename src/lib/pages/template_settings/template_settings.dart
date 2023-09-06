import 'package:flutter/material.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/template_setting_service.dart';
import 'package:invoice/widgets/mint_y.dart';
import 'package:invoice/widgets/setting_widget.dart';
import 'package:invoice/widgets/template_setting_widget.dart';

// \newcommand{\invoiceSalutation}{Sehr geehrte Damen und Herren,} % die Anrede
// \newcommand{\invoiceText}{für die von mir erbrachte Leistung erhalten Sie hiermit die Rechnung. Bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\invoiceReference) bis zum \payDate \ auf das angegebene Konto ein.} % Rechnungstext
// \newcommand{\invoiceHint}{Im ausgewiesenen Betrag ist gemäß § 19 UStG keine Umsatzsteuer enthalten.}
// \newcommand{\invoiceClosing}{Mit freundlichen Grüßen}

// % ################## Personal DATA ##################
// % START INVOICE DATA
// %\newcommand{\taxID}{#!DEACTIVATED!#}
// % END INVOICE DATA
// % START SENDERS DATA
// \newcommand{\senderName}{Jean Doe}
// \newcommand{\senderStreet}{Meine-Str. 125}
// \newcommand{\senderZIP}{67890}
// \newcommand{\senderCity}{Musterstadt}
// \newcommand{\senderTelephone}{+49 (0)33445 9876345}
// \newcommand{\senderMobilephone}{+49 (0)151 29134704}
// \newcommand{\senderEmail}{mail@domain.de}
// \newcommand{\senderWeb}{\url{www.domain.com}}
// % END SENDERS DATA
// % START ACCOUNT DATA
// \newcommand{\accountBankName}{DAB-Bank}
// \newcommand{\accountIBAN}{DE00 3006 0088 1234 5678 90}
// \newcommand{\accountBIC}{DRTTZZUUXXX}

class TemplateSettingsPage extends StatelessWidget {
  const TemplateSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Vorlagen-Einstellungen",
      contentElements: [
        TemplateSettingWidgetTextLine(
            description: "Ihr Name",
            defaultValue: "Max Mustermann",
            csvKey: "SEN-NAME"),
        TemplateSettingWidgetTextLine(
            description: "Straße",
            defaultValue: "Musterstraße 12",
            csvKey: "SEN-STREET"),
        TemplateSettingWidgetTextLine(
            description: "PLZ", defaultValue: "12345", csvKey: "SEN-ZIP"),
        TemplateSettingWidgetTextLine(
            description: "Stadt",
            defaultValue: "Musterstadt",
            csvKey: "SEN-CITY"),
        TemplateSettingWidgetTextLine(
            description: "Telefon",
            defaultValue: "+49 (0)123 456789",
            csvKey: "SEN-PHONE"),
        TemplateSettingWidgetTextLine(
          description: "E-Mail",
          defaultValue: "",
          csvKey: "SEN-EMAIL",
        ),
        TemplateSettingWidgetTextLine(
            description: "Webseite",
            defaultValue: "www.domain.com",
            csvKey: "SEN-WEBSITE"),
        TemplateSettingWidgetTextLine(
            description: "Bank",
            defaultValue: "DAB-Bank",
            csvKey: "MONEY-INSTITUTE"),
        TemplateSettingWidgetTextLine(
            description: "IBAN",
            defaultValue: "DE00 3006 0088 1234 5678 90",
            csvKey: "IBAN"),
        TemplateSettingWidgetTextLine(
            description: "BIC", defaultValue: "DRTTZZUUXXX", csvKey: "BIC"),
        TemplateSettingWidgetTextLine(
            description: "USt-IdNr.",
            defaultValue: "DE123456789",
            csvKey: "SEN-TAX-ID"),
        TemplateSettingWidgetTextLine(
          description: "Anrede",
          defaultValue: "Sehr geehrte Damen und Herren,",
          csvKey: "SALUTATION",
        ),
        TemplateSettingWidgetTextLine(
            description: "Rechnungstext",
            defaultValue:
                "bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\\invoiceReference) bis zum \\payDate \\ auf das angegebene Konto ein.",
            csvKey: "MESSAGE"),
        TemplateSettingWidgetTextLine(
          description: "Rechnungshinweis",
          defaultValue:
              "Das Leistungsdatum entspricht dem Rechnungsdatum. Der angegebene Preis ist ein Endpreis. Gemäß 19 § UStG erhebe ich keine Umsatzsteuer und weise diese folglich auch nicht aus.",
          csvKey: "HINT",
        ),
        TemplateSettingWidgetTextLine(
            description: "Rechnungsabschluss",
            defaultValue: "Mit freundlichen Grüßen",
            csvKey: "CLOSING"),
        SettingWidgetTextLine(
            description: "Absoluter Pfad zum Logo\n(.png, bis 150px)",
            defaultValue: "/home/benutzer/Bilder/logo.png",
            configKey: "logoPath"),
        SettingWidgetTextLine(
            description: "Standard Steuersatz (in %)",
            defaultValue: "0",
            configKey: "defaultVatRate"),
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MintYButton(
            text: const Text("Zurück", style: MintY.heading4White),
            onPressed: () {
              /// Trigger init to reload the settings from file
              /// and destroy temporary settings, which the user could have made
              /// but not saved
              TemplateSettingService.init();
              ConfigHandler.loadConfigFromFile();

              Navigator.pop(context);
            },
            color: MintY.currentColor,
          ),
          const SizedBox(width: 20),
          MintYButton(
            text: const Text("Alles Speichern", style: MintY.heading4White),
            onPressed: () {
              TemplateSettingService.saveAllTemplateSettings();
              ConfigHandler.saveConfigToFile();
              Navigator.pop(context);
            },
            color: MintY.currentColor,
          )
        ],
      ),
    );
  }
}
