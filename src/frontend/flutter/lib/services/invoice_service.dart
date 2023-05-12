import 'dart:io';

import 'package:invoice/datatypes/invoice_element.dart';
import 'package:invoice/services/config_service.dart';

class InvoiceService {
  static List<InvoiceElement> invoiceElements = [
    InvoiceElement(
        type: InvoiceElementType.article,
        name: "Gummibärchen Silber",
        pricePerUnit: 12,
        amount: 10),
    InvoiceElement(
        type: InvoiceElementType.article,
        name: "Gummibärchen Gold",
        pricePerUnit: 7,
        amount: 6),
  ];

  // CURRENT CUSTOMER DATA

  static String currentCompanyName = "";
  static String currentContactPerson = "";

  /// House number and street
  static String currentCustomerStreet = "";
  static String currentCustomerZip = "";
  static String currentCustomerCity = "";

  static void deleteInvoiceElement(int id) {
    invoiceElements.removeWhere((element) => element.id == id);
  }

  static void generateInvoice() async {
    // Call pyhton script this is the help:
    //     usage: invoice-generator.py [-h] [--customerCompany CUSTOMERCOMPANY] [--customerName CUSTOMERNAME] [--customerStreet CUSTOMERSTREET]
    //                             [--customerZIP CUSTOMERZIP] [--customerCity CUSTOMERCITY] [--customerCountry CUSTOMERCOUNTRY]
    //                             [--article ARTICLE [ARTICLE ...]] [--expense EXPENSE [EXPENSE ...]] [--discount DISCOUNT]
    //                             [--template TEMPLATE] [--paymentDays PAYMENTDAYS] [--invoiceNumber INVOICENUMBER] [--logo LOGO]

    // German invoice generator.

    // options:
    //   -h, --help            show this help message and exit
    //   --customerCompany CUSTOMERCOMPANY
    //                         Name of the company
    //   --customerName CUSTOMERNAME
    //                         Name of the customer
    //   --customerStreet CUSTOMERSTREET
    //                         Street of the customer
    //   --customerZIP CUSTOMERZIP
    //                         Postal code of the customer
    //   --customerCity CUSTOMERCITY
    //                         City of the customer
    //   --customerCountry CUSTOMERCOUNTRY
    //                         Country of the customer
    //   --article ARTICLE [ARTICLE ...]
    //                         One or more articles. Format: --article "<description>;<pricePerUnit>;<amount>"
    //                         "<description>;<pricePerUnit>;<amount>"
    //   --expense EXPENSE [EXPENSE ...]
    //                         One or more expenses. Format: --expense "<description>;<price>" "<description>;<price>"
    //   --discount DISCOUNT   Discount in euro. Format: --discount "Discount;25"
    //   --template TEMPLATE   Path to the template file. Default: template.tex
    //   --paymentDays PAYMENTDAYS
    //                         Number of days until payment is due. Default: 14
    //   --invoiceNumber INVOICENUMBER
    //                         Invoice number if you want to override. Default: YYYY-MM-<number>
    //   --logo LOGO           Path to the logo. Default: logo.png

    // Change working directory to python script ../../backend/python
    Directory pythonWorkingDir = Directory("../../backend/python");

    var arguments = [
      "invoice-generator.py",
      "--customerCompany",
      currentCompanyName,
      "--customerName",
      currentContactPerson,
      "--customerStreet",
      currentCustomerStreet,
      "--customerZIP",
      currentCustomerZip,
      "--customerCity",
      currentCustomerCity,
    ];

    // Add articles
    var articles = invoiceElements
        .where((element) => element.type == InvoiceElementType.article);
    if (articles.isNotEmpty) {
      arguments.add("--article");
      for (var element in articles) {
        String s = "${element.name};${element.pricePerUnit};${element.amount}";
        arguments.add(s);
      }
    }

    // Add expenses
    var expenses = invoiceElements
        .where((element) => element.type == InvoiceElementType.expense);
    if (expenses.isNotEmpty) {
      arguments.add("--expense");
      for (var element in expenses) {
        String s = "${element.name};${element.pricePerUnit}";
        arguments.add(s);
      }
    }

    // Add discount
    var discount = invoiceElements
        .where((element) => element.type == InvoiceElementType.discount);
    if (discount.isNotEmpty) {
      arguments.add("--discount");
      for (var element in discount) {
        String s = "${element.name};${element.pricePerUnit}";
        arguments.add(s);
      }
    }

    // Add logo
    String logoPath = ConfigHandler.getValueUnsafe("logoPath", "");
    if (logoPath != "") {
      arguments.add("--logo");
      arguments.add(logoPath);
    }

    var result = await Process.run("/usr/bin/python3", arguments,
        workingDirectory: pythonWorkingDir.path);
    Process.run("touch", ["do"], workingDirectory: pythonWorkingDir.path);

    // Get stout from python script
    print(result.stdout.toString());
    print(result.stderr.toString());

    // // pdflatex -output-directory=../  _main.tex
    // Directory latexWorkingDir = Directory("../backend/latex");
    // result = await Process.run(
    //     "/usr/bin/pdflatex", ["-output-directory=../", "_main.tex"],
    //     workingDirectory: latexWorkingDir.path);

    // // Get stout from python script
    // print(result.stdout.toString());
    // print(result.stderr.toString());
  }
}
