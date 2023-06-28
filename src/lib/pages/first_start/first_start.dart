import 'package:flutter/material.dart';
import 'package:invoice/pages/first_start/basic_data.dart';
import 'package:invoice/widgets/mint_y.dart';

class FirstStartPage extends StatelessWidget {
  const FirstStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Lasst uns Rechnungen schreiben!",
      contentElements: [
        Text(
          "Dein Rechnungs Assistent.",
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "In den folgenden Schritten werden wir gemeinsam die Adress-Daten und Zahlungsdaten Deines Unternehmens einrichten.\nEbenfalls werden wir die Texte für die Rechnungsvorlage festlegen.\nDer Rechnungs Assistent ist aktuell nur für Kleinunternehmer geeignet.\nEs wird keine Haftung für die Richtigkeit der Rechnungen übernommen.",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MintYButtonNavigate(
              route: const BasicDataEnteringPage(),
              text:
                  const Text("Lasst uns loslegen!", style: MintY.heading4White),
              width: 300,
              color: MintY.currentColor,
            ),
          ],
        )
      ],
    );
  }
}
