import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invoice/models/invoice_element.dart';
import 'package:invoice/pages/invoice_creation/invoice_waiting_screen.dart';
import 'package:invoice/services/helpers.dart';
import 'package:invoice/services/template_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class InvoiceService {
  /// If the folder was opened after invoice creation in the file manager
  static bool opendInvoiceFolder = false;

  static List<InvoiceElement> invoiceElements = [];

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

  static void clearInvoiceElements() {
    invoiceElements.clear();
    currentCompanyName = "";
    currentContactPerson = "";
    currentCustomerStreet = "";
    currentCustomerZip = "";
    currentCustomerCity = "";
  }

  static void generateInvoice(
      {bool preview = false, required BuildContext context}) async {
    if ((currentCompanyName == "" && currentContactPerson == "") ||
        currentCustomerStreet == "" ||
        currentCustomerZip == "" ||
        currentCustomerCity == "") {
      MintY.showMessage(
          context, "Bitte füllen Sie die Kundenanschrift ausreichend aus!");
      return;
    }
    if (invoiceElements.isEmpty) {
      MintY.showMessage(context,
          "Bitte fügen Sie mindestens eine Rechnungsposition hinzu!\nDefinieren Sie die Artikelbeschreibung, den Preis pro Einheit und die Menge.\nDrücken Sie am Ende den '+' Knopf.");
      return;
    }

    // Navigate to waiting screen
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InvoiceCreationWaitingPage(
                  creationFunction: _generateInvoice(preview: preview),
                )));
  }

  static Future<void> _generateInvoice({
    bool preview = false,
  }) async {
    var arguments = [
      "generator-html.py",
      "--template",
      "${getInvoicesDirectory()}/data/templates/${TemplateService.currentTemplate.fileName}",
      // "${getConfigDirectory()}/template.csv", // TODO: Change path
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

    if (preview) {
      arguments.add("--dryRun");
    }

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
        String s = "${element.name};${element.price}";
        arguments.add(s);
      }
    }

    // Add discount
    var discount = invoiceElements
        .where((element) => element.type == InvoiceElementType.discount);
    if (discount.isNotEmpty) {
      arguments.add("--discount");
      for (var element in discount) {
        String s = "${element.name};${element.price}";
        arguments.add(s);
      }
    }

    var result = await Process.run("/usr/bin/python3", arguments);

    String pathOfPrintedInvoice = "";
    for (String line in result.stdout.split("\n")) {
      if (line.startsWith("InvoicePath:")) {
        pathOfPrintedInvoice = line.replaceAll("InvoicePath:", "").trim();
      }
    }

    // print(result.stdout);
    // print(result.stderr);

    // Get current month and year
    var now = DateTime.now();
    String month = now.month.toString().padLeft(2, "0");
    String year = now.year.toString();

    if (preview) {
      Process.run("xdg-open", ["${getCacheDirectory()}/Rechnung.pdf"]);
    } else {
      if (opendInvoiceFolder == false) {
        opendInvoiceFolder = true;
        Process.run("xdg-open", ["${getInvoicesDirectory()}/$year/$month/"]);
      }
      if (pathOfPrintedInvoice != "") {
        Process.run("xdg-open", [pathOfPrintedInvoice]);
      }
      clearInvoiceElements();
    }
  }
}
