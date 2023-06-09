import 'package:flutter/material.dart';
import 'package:invoice/services/template_setting_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class TemplateSettingWidgetTextLine extends StatelessWidget {
  String description = '';
  String defaultValue = '';
  String value = '';
  String latexKey = '';
  bool displaySaveButton;

  TemplateSettingWidgetTextLine(
      {super.key,
      required this.description,
      required this.defaultValue,
      required this.latexKey,
      this.displaySaveButton = true}) {
    if (TemplateSettingService.templateSettings[latexKey] != null) {
      value = TemplateSettingService.templateSettings[latexKey]!;
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
            TemplateSettingService.templateSettings[latexKey] =
                value.replaceAll("\n", " ");
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
                  TemplateSettingService.saveValue(latexKey, value);
                  controller.text = value;
                },
              )
            : Container(),
      ],
    );
  }
}
