import 'dart:io';

import 'package:invoice/services/helpers.dart';

class TemplateSettingService {
  /// In here also temporary settings are stored, which the user did not save yet
  /// /// (only while the user is in the settings screen)
  static Map<String, String> templateSettings = {};

  /// Saves all template settings, which the user could have changed
  static void saveAllTemplateSettings() {
    for (String key in templateSettings.keys) {
      saveValue(key, templateSettings[key]!);
    }
  }

  static List<String> _getLinesFromSettingsFile() {
    // if the template file does not exist, copy it from latex/template.tex
    File templateFile = File('${getConfigDirectory()}/template.csv');
    if (!templateFile.existsSync()) {
      File('html/template.csv.example')
          .copySync('${getConfigDirectory()}/template.csv');
    }

    // read the template file in a list of lines
    List<String> templateLines = templateFile.readAsLinesSync();
    return templateLines;
  }

  static void init() {
    // Load template settings from local storage at path: /backend/python/template.tex

    List<String> templateLines = _getLinesFromSettingsFile();

    // Read the lines and store the settings in the templateSettings map
    for (String line in templateLines) {
      line = line.trim();
      List<String> elements = line.split(";");
      if (elements.length == 2) {
        templateSettings[elements[0]] = elements[1];
      }
    }
  }

  static void saveValue(String key, String value) {
    // Save the value in the templateSettings map
    templateSettings[key] = value;
    // Save the templateSettings map in the template file
    List<String> templateLines = _getLinesFromSettingsFile();

    // Read the lines and store the settings in the templateSettings map
    bool settingSet = false;
    for (int i = 0; i < templateLines.length; i++) {
      String line = templateLines[i];
      if (line.trim().startsWith("$key;")) {
        if (value.trim() == "") {
          // If the value is empty, delete the setting
          templateLines.removeAt(i);
          settingSet = true;
          break;
        }
        // If the setting is already set, replace it
        templateLines[i] = "$key;$value";
        settingSet = true;
        break;
      }
    }
    if (!settingSet) {
      // If the setting is not set, add it to the end of the file
      templateLines.add("$key;$value");
    }
    // Write the templateLines to the template file
    File templateFile = File('${getConfigDirectory()}/template.csv');
    templateFile.writeAsStringSync(templateLines.join('\n'));
  }
}
