import 'dart:io';

import 'package:invoice/services/helpers.dart';

class TemplateSettingService {
  static Map<String, String> templateSettings = {};

  static List<String> _getLinesFromSettingsFile() {
    // if the template file does not exist, copy it from latex/template.tex
    File templateFile = File('${getConfigDirectory()}/template.tex');
    if (!templateFile.existsSync()) {
      File('latex/template.tex.example')
          .copySync('${getConfigDirectory()}/template.tex');
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
      if (line.startsWith(r'\newcommand{')) {
        // Remove the latex comment from the line
        line = line.split('%')[0];
        line.trim();
        // Remove the \newcommand{ and the } from the line
        String lineWithoutNewcommand = line.substring(12, line.length - 1);
        // Split the line at the }{ to get the key and the value
        List<String> lineSplit = lineWithoutNewcommand.split("}{");
        lineSplit[0] = lineSplit[0].replaceAll('\\', "");
        // Store the key and the value in the templateSettings map
        templateSettings[lineSplit[0]] = lineSplit[1];
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
      if (line.startsWith(r'\newcommand{')) {
        // Remove the latex comment from the line
        line = line.split('%')[0];
        line.trim();
        // Remove the \newcommand{ and the } from the line
        String lineWithoutNewcommand = line.substring(12, line.length - 1);
        // Split the line at the }{ to get the key and the value
        List<String> lineSplit = lineWithoutNewcommand.split("}{");
        lineSplit[0] = lineSplit[0].replaceAll('\\', "");
        // Check if the key is the same as the key we are looking for
        if (lineSplit[0] == key) {
          if (value.isEmpty) {
            // If the key is empty, remove the line
            templateLines.removeAt(i);
            i--;
            settingSet = true;
            continue;
          }
          // If the key is the same, replace the value
          templateLines[i] = r'\newcommand{\' + key + r'}{' + value + r'}';
          settingSet = true;
        }
      }
    }
    if (!settingSet) {
      // If the setting is not set, add it to the end of the file
      templateLines.add(r'\newcommand{\' + key + r'}{' + value + r'}');
    }
    // Write the templateLines to the template file
    File templateFile = File('${getConfigDirectory()}/template.tex');
    templateFile.writeAsStringSync(templateLines.join('\n'));
  }
}
