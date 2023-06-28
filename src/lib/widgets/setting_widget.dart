import 'package:flutter/material.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/widgets/mint_y.dart';

/// Uses the config handler to store and retrieve settings
class SettingWidgetTextLine extends StatelessWidget {
  String description = '';
  String defaultValue = '';
  String value = '';
  String configKey = '';

  SettingWidgetTextLine(
      {super.key,
      required this.description,
      required this.defaultValue,
      required this.configKey}) {
    value = ConfigHandler.getValueUnsafe(configKey, defaultValue);
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

            /// Safe the value to the config map.
            /// The user can trigger a save to the config file by pressing the
            /// save button on the bottom of the settings page.
            ConfigHandler.setValueUnsafe(configKey, value);
          },
          controller: controller,
        ),
        const SizedBox(
          width: 20,
        ),
        MintYButton(
          text: const Icon(
            Icons.save,
            color: Colors.white,
          ),
          width: 50,
          color: MintY.currentColor,
          onPressed: () {
            ConfigHandler.setValue(configKey, value);
          },
        )
      ],
    );
  }
}
