import 'package:flutter/material.dart';
import 'package:invoice/models/template.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class TemplateSettingWidgetTextLine extends StatelessWidget {
  String description = '';
  String defaultValue = '';
  String value = '';
  String csvKey = '';
  String information = '';
  bool displaySaveButton;
  Template template;

  TemplateSettingWidgetTextLine(
      {super.key,
      required this.description,
      required this.defaultValue,
      required this.csvKey,
      required this.template,
      this.information = "",
      this.displaySaveButton = true}) {
    if (template.templateData[csvKey] != null) {
      value = template.templateData[csvKey]!;
    }
  }

  // Controller:
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            description,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        MintYTextField(
          width: 400,
          maxLines: value.length > 50 ? 8 : 1,
          hintText: defaultValue,
          onChanged: (String newValue) {
            value = newValue;
            template.templateData[csvKey] = value.replaceAll("\n", " ");
          },
          controller: controller,
        ),
        const SizedBox(
          width: 20,
        ),
        displaySaveButton
            ? MintYButton(
                text: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                width: 50,
                color: MintY.currentColor,
                onPressed: () {
                  // Replace new line with spaces because it will otherwise crash the .latex file
                  value = value.replaceAll("\n", " ");
                  TemplateService.saveValue(template, csvKey, value);
                  controller.text = value;
                },
              )
            : Container(),
        information != ""
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MintYButton(
                  text: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  width: 50,
                  color: MintY.currentColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(description),
                          content: Text(information),
                          actions: <Widget>[
                            MintYButton(
                              color: MintY.currentColor,
                              text: const Text("Schließen",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            : Container(
                width: 90,
              ),
      ],
    );
  }
}
