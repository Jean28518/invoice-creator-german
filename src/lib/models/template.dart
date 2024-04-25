class Template {
  String fileName = '';
  String get templateName {
    if (templateData['TEMPLATE-NAME'] != null) {
      return templateData['TEMPLATE-NAME']!;
    }
    return '';
  }

  set templateName(String value) {
    templateData['TEMPLATE-NAME'] = value;
  }

  Map<String, String> templateData = {};

  Template({required this.fileName, required this.templateData});

  String getCurrency() {
    if (templateData['CURRENCY'] != null) {
      return templateData['CURRENCY']!;
    }
    return "€";
  }
}
