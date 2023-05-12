import 'dart:convert';
import 'dart:io';

import 'package:invoice/services/helpers.dart';

class ConfigHandler {
  static Map<String, dynamic> configMap = {
    "config_initialized": false,
  };

  static Future<dynamic> getValue(key, defaultValue) async {
    await ensureConfigIsLoaded();
    return getValueUnsafe(key, defaultValue);
  }

  /// ensure that the config is loaded into memory before!! (call ensureConfigIsLoaded() before)
  /// that has only to be done once per programm start
  static dynamic getValueUnsafe(key, defaultValue) {
    if (configMap.containsKey(key)) {
      return configMap[key];
    } else {
      return defaultValue;
    }
  }

  /// Ensures that the config is loaded into memory before
  /// Also ensures that the config is saved to file after
  /// You may directly access the saved variable with getValueUnsafe()
  static Future<void> setValue(key, value) async {
    await ensureConfigIsLoaded();
    setValueUnsafe(key, value);
    await saveConfigToFile();
  }

  /// ensure that the config is loaded into memory before!! (call ensureConfigIsLoaded() before)
  /// that has only to be done once per programm start
  /// also ensure that saveConfigToFile() is called once before programm exit
  static void setValueUnsafe(key, value) {
    configMap[key] = value;
  }

  static Future<void> ensureConfigIsLoaded() async {
    if (!configMap["config_initialized"]) {
      await loadConfigFromFile();
    }
  }

  static Future<void> loadConfigFromFile() async {
    File configFile = File("${getConfigDirectory()}config.json");
    if (!await configFile.exists()) {
      await Process.run("/usr/bin/mkdir", [
        "-p",
        getConfigDirectory(),
      ]);
      configMap["config_initialized"] = true;
    } else {
      String configString = await configFile.readAsString();
      configMap = jsonDecode(configString);
      configMap["config_initialized"] = true;
    }
  }

  static Future<void> saveConfigToFile() async {
    await ensureConfigIsLoaded();
    String configString = jsonEncode(configMap);
    File configFile = File("${getConfigDirectory()}config.json");
    await configFile.writeAsString(configString);
  }
}
