import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invoice/datatypes/invoice_element.dart';
import 'package:invoice/pages/invoice_creation/invoice_creation.dart';
import 'package:invoice/pages/invoice_creation/invoice_waiting_screen.dart';
import 'package:invoice/services/config_service.dart';
import 'package:invoice/services/helpers.dart';
import 'package:invoice/widgets/mint_y.dart';

class InvoiceService {
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
      MintY.showMessage(
          context, "Bitte fügen Sie mindestens eine Rechnungsposition hinzu!");
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
      "generator.py",
      "--dryRun",
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

    clearInvoiceElements();

    var result = await Process.run("/usr/bin/python3", arguments);

    String invoiceNumber = result.stdout
        .toString()
        .split("\n")
        .where((element) => element.startsWith("invoice-number: "))
        .first
        .split(" ")
        .last;

    await Process.run("touch", ["/tmp/rechnungs-assistent/do"]);

    // Wait for file to be generated
    await Future.delayed(const Duration(milliseconds: 3000));

    // Get current month and year
    var now = DateTime.now();
    String month = now.month.toString().padLeft(2, "0");
    String year = now.year.toString();

    if (preview) {
      Process.run("xdg-open", ["${getCacheDirectory()}/latex/_main.pdf"]);
    } else {
      await Process.run("mv", [
        "${getCacheDirectory()}/latex/_main.pdf",
        "${getInvoicesDirectory()}/$year/$month/Rechnung-$invoiceNumber.pdf"
      ]);
      // Process.run("xdg-open", ["${getInvoicesDirectory()}/$year/$month/"]);
    }
  }
}
