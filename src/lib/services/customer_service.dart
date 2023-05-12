import 'dart:io';

import 'package:invoice/datatypes/customer.dart';
import 'package:invoice/services/helpers.dart';

// CSV: template: companyName;name;street;zip;city;country

class CustomerService {
  static List<Customer> customers = [];

  static void init() {
    // load and parse .csv file from config folder
    File customerFile = File("${getInvoicesDirectory()}/data/customers.csv");
    if (!customerFile.existsSync()) {
      customerFile.createSync(recursive: true);
    }
    List<String> lines = customerFile.readAsLinesSync();
    for (int i = 1; i < lines.length; i++) {
      String line = lines[i];
      List<String> lineSplit = line.split(";");
      Customer customer = Customer(
        companyName: lineSplit[0],
        name: lineSplit[1],
        street: lineSplit[2],
        zip: lineSplit[3],
        city: lineSplit[4],
        country: lineSplit[5],
      );
      customers.add(customer);
    }
  }

  static void save() {
    // save customers to .csv file in config folder
    File customerFile = File("${getConfigDirectory()}customers.csv");
    List<String> lines = ["companyName;name;street;zip;city;country"];
    for (Customer customer in customers) {
      lines.add(
          '${customer.companyName};${customer.name};${customer.street};${customer.zip};${customer.city};${customer.country}');
    }
    customerFile.writeAsStringSync(lines.join("\n"));
  }
}
