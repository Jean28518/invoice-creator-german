import 'dart:io';

import 'package:invoice/models/template.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/helpers.dart';

class TemplateService {
  static List<Template> templates = [];

  static Template currentTemplate = Template(
    fileName: "",
    templateData: {"TEMPLATE-NAME": "Kein Template gefunden"},
  );

  static void init() {
    templates = [];
    // load and parse .csv file from config folder
    // Ensure that the directory exists
    Directory('${getInvoicesDirectory()}/data/templates')
        .createSync(recursive: true);
    final dir = Directory('${getInvoicesDirectory()}/data/templates');
    List<FileSystemEntity> files = dir.listSync(recursive: false);

    for (int i = 0; i < files.length; i++) {
      if (!files[i].path.endsWith(".csv")) {
        continue;
      }
      String fileName = files[i].path.split("/").last;
      // Parse csv file
      List<String> lines = File(files[i].path).readAsLinesSync();
      Map<String, String> templateData = {};
      for (String line in lines) {
        List<String> lineSplit = line.split(";");
        assert(lineSplit.length == 2);
        templateData[lineSplit[0]] = lineSplit[1];
      }
      Template template = Template(
        fileName: fileName,
        templateData: templateData,
      );
      templates.add(template);
    }
    if (templates.isEmpty) {
      createTemplate("Standard");
      return;
    }

    templates.sort((a, b) => a.templateName.compareTo(b.templateName));
    int index = ConfigHandler.getValueUnsafe("current_template", 0);
    if (index >= templates.length) {
      index = 0;
    }
    currentTemplate = templates[index];
  }

  static void createTemplate(String templateName) {
    String fileName = generateFilenameOfTemplateName(templateName);
    fileName = "$fileName.csv";

    // save template to .csv file in config folder
    File templateFile = File(
        "${getInvoicesDirectory()}/data/templates/${templateName.replaceAll(" ", "_")}.csv");
    List<String> lines = ["TEMPLATE-NAME;$templateName"];
    // TODO: Create all template data fields in the csv file
    List<String> defaultFields =
        File("html/template.csv.example").readAsLinesSync();
    lines.addAll(defaultFields);
    templateFile.writeAsStringSync(lines.join("\n"));
    init();
  }

  static Template getTemplateByName(String templateName) {
    for (int i = 0; i < templates.length; i++) {
      if (templates[i].templateName == templateName) {
        return templates[i];
      }
    }
    return Template(
      fileName: "",
      templateData: {"TEMPLATE-NAME": "Kein Template gefunden"},
    );
  }

  static void saveValue(Template template, String key, String value) {
    List<String> lines = File(getPathToTemplate(template)).readAsLinesSync();
    bool settingSet = false;
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (line.trim().startsWith("$key;")) {
        // If the setting is already set, replace it
        lines[i] = "$key;$value";
        settingSet = true;
        break;
      }
    }
    if (!settingSet) {
      // If the setting is not set, add it to the end of the file
      lines.add("$key;$value");
    }
    template.templateData[key] = value;
    File(getPathToTemplate(template)).writeAsStringSync(lines.join('\n'));
  }

  static String getPathToTemplate(Template template) {
    return "${getInvoicesDirectory()}/data/templates/${template.fileName}";
  }

  static String generateFilenameOfTemplateName(String templateName) {
    String fileName = templateName
        .replaceAll(" ", "_")
        .replaceAll("/", "")
        .replaceAll(".", "");
    if (!fileName.endsWith(".csv")) {
      fileName = "$fileName.csv";
    }
    return fileName;
  }

  static void deleteTemplate(Template template) {
    templates.remove(template);
    File(getPathToTemplate(template)).deleteSync();
    if (currentTemplate == template) {
      currentTemplate = templates[0];
    }
  }

  static void copyTemplate(Template template, String newTemplateName) {
    String newFileName = generateFilenameOfTemplateName(newTemplateName);
    if (newFileName == template.fileName) {
      return;
    }
    File(getPathToTemplate(template))
        .copySync("${getInvoicesDirectory()}/data/templates/$newFileName");
    Template newTemplate = Template(
        fileName: newFileName, templateData: Map.from(template.templateData));
    // Save the template name
    saveValue(newTemplate, "TEMPLATE-NAME", newTemplateName);
  }

  static void setCurrentTemplate(String templateName) {
    for (int i = 0; i < templates.length; i++) {
      if (templates[i].templateName == templateName) {
        currentTemplate = templates[i];
        ConfigHandler.setValue("current_template", i);
        return;
      }
    }
  }

  static void saveTemplate(Template template) {
    for (String key in template.templateData.keys) {
      saveValue(template, key, template.templateData[key]!);
    }
  }
}
