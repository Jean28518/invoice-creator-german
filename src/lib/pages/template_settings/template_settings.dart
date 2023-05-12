import 'package:flutter/material.dart';
import 'package:invoice/services/template_setting_service.dart';
import 'package:invoice/widgets/mint_y.dart';
import 'package:invoice/widgets/setting_widget.dart';
import 'package:invoice/widgets/template_setting_widget.dart';

// \newcommand{\invoiceSalutation}{Sehr geehrte Damen und Herren,} % die Anrede
// \newcommand{\invoiceText}{für die von mir erbrachte Leistung erhalten Sie hiermit die Rechnung. Bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\invoiceReference) bis zum \payDate \ auf das angegebene Konto ein.} % Rechnungstext
// \newcommand{\invoiceHint}{Im ausgewiesenen Betrag ist gemäß § 19 UStG keine Umsatzsteuer enthalten.}
// \newcommand{\invoiceEnclosures}{} % \encl{} einfügen
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
  TemplateSettingsPage({super.key}) {
    TemplateSettingService.init();
  }

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Vorlagen-Einstellungen",
      contentElements: [
        TemplateSettingWidgetTextLine(
            description: "Ihr Name",
            defaultValue: "Max Mustermann",
            latexKey: "senderName"),
        TemplateSettingWidgetTextLine(
            description: "Straße",
            defaultValue: "Musterstraße 12",
            latexKey: "senderStreet"),
        TemplateSettingWidgetTextLine(
            description: "PLZ", defaultValue: "12345", latexKey: "senderZIP"),
        TemplateSettingWidgetTextLine(
            description: "Stadt",
            defaultValue: "Musterstadt",
            latexKey: "senderCity"),
        TemplateSettingWidgetTextLine(
            description: "Telefon",
            defaultValue: "+49 (0)123 456789",
            latexKey: "senderTelephone"),
        TemplateSettingWidgetTextLine(
            description: "Mobil",
            defaultValue: "+49 (0)123 456789",
            latexKey: "senderMobilephone"),
        TemplateSettingWidgetTextLine(
          description: "E-Mail",
          defaultValue: "",
          latexKey: "senderEmail",
        ),
        TemplateSettingWidgetTextLine(
            description: "Webseite",
            defaultValue: "www.domain.com",
            latexKey: "senderWeb"),
        TemplateSettingWidgetTextLine(
            description: "Bank",
            defaultValue: "DAB-Bank",
            latexKey: "accountBankName"),
        TemplateSettingWidgetTextLine(
            description: "IBAN",
            defaultValue: "DE00 3006 0088 1234 5678 90",
            latexKey: "accountIBAN"),
        TemplateSettingWidgetTextLine(
            description: "BIC",
            defaultValue: "DRTTZZUUXXX",
            latexKey: "accountBIC"),
        TemplateSettingWidgetTextLine(
            description: "USt-IdNr.",
            defaultValue: "DE123456789",
            latexKey: "taxID"),
        TemplateSettingWidgetTextLine(
            description: "Rechnungstext",
            defaultValue:
                "für die von mir erbrachte Leistung erhalten Sie hiermit die Rechnung. Bitte zahlen Sie den unten aufgeführten Gesamtbetrag unter Angabe der Rechnungsnummer (\\invoiceReference) bis zum \\payDate \\ auf das angegebene Konto ein.",
            latexKey: "invoiceText"),
        TemplateSettingWidgetTextLine(
          description: "Rechnungshinweis",
          defaultValue:
              "Im ausgewiesenen Betrag ist gemäß § 19 UStG keine Umsatzsteuer enthalten.",
          latexKey: "invoiceHint",
        ),
        TemplateSettingWidgetTextLine(
            description: "Rechnungsabschluss",
            defaultValue: "Mit freundlichen Grüßen",
            latexKey: "invoiceClosing"),
        TemplateSettingWidgetTextLine(
          description: "Anrede",
          defaultValue: "Sehr geehrte Damen und Herren,",
          latexKey: "invoiceSalutation",
        ),
        SettingWidgetTextLine(
            description: "Pfad zu Ihrem Logo\n(bis 150px)",
            defaultValue: "",
            configKey: "logoPath"),
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MintYButton(
            text: const Text("Zurück", style: MintY.heading4White),
            onPressed: () {
              Navigator.pop(context);
            },
            color: MintY.currentColor,
          )
        ],
      ),
    );
  }
}
