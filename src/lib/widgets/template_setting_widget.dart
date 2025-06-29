import 'package:flutter/material.dart';
import 'package:invoice/models/template.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class TemplateSettingWidgetTextLine extends StatelessWidget {
  String description = '';
  String defaultValue = '';
  String value = '';

  /// csvKey is only the number if we are using this as an additional field.
  String csvKey = '';
  String information = '';
  bool displaySaveButton;
  Template template;
  bool additionalField = false;

  TemplateSettingWidgetTextLine({
    super.key,
    required this.description,
    required this.defaultValue,
    required this.csvKey,
    required this.template,
    this.information = "",
    this.displaySaveButton = true,
    this.additionalField = false,
  }) {
    if (additionalField) {
      // if (template.templateData["custom__value_$csvKey"] != null) {
      // If this is an additional field, we use a custom key
      value = template.templateData["custom__value_$csvKey"] ?? "";
      // }
    } else {
      // Otherwise, we use the original csvKey
      value = template.templateData[csvKey] ?? "";
    }
  }

  // Controller:
  TextEditingController valueTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    valueTextEditingController.text = value;
    descriptionTextEditingController.text = description;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        additionalField
            ? MintYTextField(
                width: 200,
                maxLines: 1,
                hintText: "Titel",
                onChanged: (String newDescription) {
                  description = newDescription;
                  template.templateData["custom__title_$csvKey"] =
                      newDescription.replaceAll("\n", " ");
                },
                controller: descriptionTextEditingController,
              )
            : SizedBox(
                width: 200,
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
        const SizedBox(
          width: 20,
        ),
        MintYTextField(
          width: 400,
          maxLines: value.length > 50 ? 8 : 1,
          // Only display the hint if this is not an additional field.
          hintText: additionalField ? "" : defaultValue,
          onChanged: (String newValue) {
            value = newValue;
            if (additionalField) {
              // If this is an additional field, we save it with a custom key
              template.templateData["custom__value_$csvKey"] =
                  value.replaceAll("\n", " ");
            } else {
              // Otherwise, we save it with the original csvKey
              template.templateData[csvKey] = value.replaceAll("\n", " ");
            }
          },
          controller: valueTextEditingController,
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
                  if (additionalField) {
                    // If this is an additional field, we save it with a custom key
                    template.templateData["custom__value_$csvKey"] = value;
                    template.templateData["custom__title_$csvKey"] =
                        description;
                    TemplateService.saveValue(
                      template,
                      "custom__value_$csvKey",
                      value,
                    );
                    TemplateService.saveValue(
                      template,
                      "custom__title_$csvKey",
                      description,
                    );
                  } else {
                    // Otherwise, we save it with the original csvKey
                    template.templateData[csvKey] = value;
                    TemplateService.saveValue(
                      template,
                      csvKey,
                      value,
                    );
                  }
                  // Update the value in the text field controller
                  valueTextEditingController.text = value;
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
