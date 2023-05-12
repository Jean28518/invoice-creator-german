import 'dart:io';

/// If unparsable returns 0.0
double parseDouble(String s) {
  // Check if double
  if (s.contains(",")) {
    s = s.replaceAll(",", ".");
  }
  if (double.tryParse(s) != null) {
    return double.parse(s);
  }
  return 0.0;
}

String getHomeDirectory() {
  String? home = Platform.environment["HOME"];
  if (home != null) {
    if (!home.endsWith("/")) {
      home += "/";
    }
    return home;
  } else {
    return "";
  }
}

String getConfigDirectory() {
  String homeDir = getHomeDirectory();
  return "$homeDir.config/german-invoice-generator/";
}
