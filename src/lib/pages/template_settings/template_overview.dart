import 'package:flutter/material.dart';
import 'package:invoice/pages/invoice_creation/invoice_creation.dart';
import 'package:invoice/pages/template_settings/new_template.dart';
import 'package:invoice/pages/template_settings/template_settings.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class TemplateOverviewPage extends StatelessWidget {
  const TemplateOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
        title: "Vorlagen",
        customContentElement: MintYGrid(
            ratio: 2 / 1,
            widgetSize: 350,
            children: TemplateService.templates
                .map((e) => MintYCardWithIconAndAction(
                      icon: Icon(
                        Icons.description,
                        color: MintY.currentColor,
                        size: 50,
                      ),
                      title: e.templateName,
                      buttonText: "Bearbeiten",
                      text: "",
                      onPressed: () {
                        TemplateService.currentTemplate = e;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TemplateSettingsPage(
                                  template: e,
                                )));
                      },
                    ))
                .toList()),
        bottom: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MintYButtonNavigate(
                text: const Text(
                  "Zurück",
                  style: MintY.heading4,
                ),
                route: const InvoiceCreationPage()),
            const SizedBox(
              width: 20,
            ),
            MintYButtonNavigate(
              text: const Text(
                "Neue Vorlage",
                style: MintY.heading4White,
              ),
              color: MintY.currentColor,
              route: NewTemplatePage(),
            ),
          ],
        ));
  }
}
