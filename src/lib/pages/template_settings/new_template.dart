import 'package:flutter/material.dart';
import 'package:invoice/models/template.dart';
import 'package:invoice/pages/template_settings/template_settings.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class NewTemplatePage extends StatelessWidget {
  NewTemplatePage({super.key});

  String templateName = "";

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Neue Vorlage",
      contentElements: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Name der Vorlage",
                style: MintY.heading3,
              ),
              MintYTextField(
                hintText: "Vorlage 1",
                onChanged: (p0) {
                  p0 = p0.replaceAll(";", "");
                  templateName = p0;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MintYButton(
                    text: const Text(
                      "Abbrechen",
                      style: MintY.heading4,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  MintYButton(
                    text: const Text(
                      "Erstellen",
                      style: MintY.heading4White,
                    ),
                    color: MintY.currentColor,
                    onPressed: () {
                      if (templateName.trim() == "") return;

                      TemplateService.createTemplate(templateName);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TemplateSettingsPage(
                              template: TemplateService.getTemplateByName(
                                  templateName))));
                    },
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
