import 'dart:math';

import 'package:flutter/material.dart';
import 'package:invoice/datatypes/invoice_element.dart';
import 'package:invoice/services/helpers.dart';
import 'package:invoice/services/invoice_service.dart';
import 'package:invoice/widgets/mint_y.dart';

GlobalKey<InvoiceElementTableWidgetState> invoiceElementTableWidgetKey =
    GlobalKey();

class InvoiceCreationPage extends StatelessWidget {
  const InvoiceCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MintYPage(
      title: "Rechnung erstellen",
      contentElements: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AdressWidget(),
            InvoiceElementCreationWidget(),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        InvoiceElementTableWidget(key: invoiceElementTableWidgetKey),
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MintYButton(
                  text: Text(
                    "Rechnungs-Ordner öffnen",
                    style: MintY.heading4White,
                  ),
                  color: MintY.currentColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              MintYButton(
                text: Text(
                  "Vorschau",
                  style: MintY.heading4White,
                ),
                color: MintY.currentColor,
              ),
              SizedBox(
                width: 10,
              ),
              MintYButton(
                text: Text(
                  "Speichern",
                  style: MintY.heading4White,
                ),
                color: MintY.currentColor,
                onPressed: () => InvoiceService.generateInvoice(),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 200,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class InvoiceElementTableWidget extends StatefulWidget {
  const InvoiceElementTableWidget({
    super.key,
  });

  @override
  State<InvoiceElementTableWidget> createState() =>
      InvoiceElementTableWidgetState();
}

class InvoiceElementTableWidgetState extends State<InvoiceElementTableWidget> {
  // Update funktion
  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: SizedBox(
            // Width: screensize - 200
            width: MediaQuery.of(context).size.width - 200,
            height: InvoiceService.invoiceElements.length * 100,
            child: ListView.builder(
                itemCount: InvoiceService.invoiceElements.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 50,
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                  '${InvoiceService.invoiceElements[index].name} ${InvoiceService.invoiceElements[index].amount} '),
                            ),
                          ),
                          MintYButton(
                            text: Text(
                              "Löschen",
                              style: MintY.heading4White,
                            ),
                            color: MintY.currentColor,
                            onPressed: () {
                              InvoiceService.deleteInvoiceElement(
                                  InvoiceService.invoiceElements[index].id);
                              update();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class InvoiceElementCreationWidget extends StatelessWidget {
  InvoiceElementCreationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 250,
              child: MintYButton(
                text: Text(
                  "Artikel verwalten",
                  style: MintY.heading4White,
                ),
                color: MintY.currentColor,
              ),
            ),
            MintYTextLine(
              hintText: "Artikelname",
              width: 500,
            ),
            MintYTextLine(
              hintText: "Menge",
              width: 100,
            ),
            Container(
              child: MintYButton(
                text: Text(
                  "Hinzufügen",
                  style: MintY.heading4White,
                ),
                color: MintY.currentColor,
              ),
            ),
          ],
        ),
        CustomArticleCreationWidget(),
        ExpenseCreationWidget(),
        DiscountCreationWidget()
      ],
    );
  }
}

class DiscountCreationWidget extends StatelessWidget {
  DiscountCreationWidget({
    super.key,
  });

  // Define strings for the textfields
  String discountName = "";
  double discountPrice = 0;

  // Define controllers for the textfields
  TextEditingController discountNameController = TextEditingController();
  TextEditingController discountPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 250,
          child: Text(
            "Neuer Rabatt",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        MintYTextLine(
          hintText: "Rabattbeschreibung",
          width: 400,
          onChanged: (value) {
            discountName = value;
          },
          controller: discountNameController,
        ),
        MintYTextLine(
          hintText: "Preisnachlass in €",
          width: 200,
          onChanged: (value) {
            discountPrice = parseDouble(value);
          },
          controller: discountPriceController,
        ),
        Container(
          child: MintYButton(
            text: Text(
              "Hinzufügen",
              style: MintY.heading4White,
            ),
            color: MintY.currentColor,
            onPressed: () {
              // if the textfields are empty, return
              if (discountName == "" || discountPrice == 0) {
                return;
              }

              // Add the invoice element to the invoice element list
              InvoiceService.invoiceElements.add(InvoiceElement(
                  type: InvoiceElementType.discount,
                  name: discountName,
                  price: discountPrice));

              // Clear the textfields
              discountNameController.clear();
              discountPriceController.clear();

              // Update the invoice element table with the key
              final state = invoiceElementTableWidgetKey.currentState;
              if (state != null) {
                state.update();
              }
            },
          ),
        ),
      ],
    );
  }
}

class ExpenseCreationWidget extends StatelessWidget {
  ExpenseCreationWidget({
    super.key,
  });

  // Define strings for the textfields
  String expenseName = "";
  double expensePrice = 0;

  // Define controllers for the textfields
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController expensePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 250,
          child: Text(
            "Neue Aufwendung",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        MintYTextLine(
          hintText: "Aufwendungsbeschreibung",
          width: 500,
          onChanged: (p0) => {
            expenseName = p0,
          },
          controller: expenseNameController,
        ),
        MintYTextLine(
          hintText: "Preis",
          width: 100,
          onChanged: (p0) => {
            expensePrice = parseDouble(p0),
          },
          controller: expensePriceController,
        ),
        Container(
          child: MintYButton(
            text: Text(
              "Hinzufügen",
              style: MintY.heading4White,
            ),
            color: MintY.currentColor,
            onPressed: () {
              // if expense is 0 or name is empty, do nothing
              if (expensePrice == 0 || expenseName == "") {
                return;
              }

              // add the expense to the invoice elements
              InvoiceService.invoiceElements.add(
                InvoiceElement(
                  name: expenseName,
                  amount: expensePrice,
                  type: InvoiceElementType.expense,
                ),
              );

              // clear the textfields
              expenseNameController.clear();
              expensePriceController.clear();

              // update the invoice element table widget
              final state = invoiceElementTableWidgetKey.currentState;
              if (state != null) {
                state.update();
              }
            },
          ),
        ),
      ],
    );
  }
}

class CustomArticleCreationWidget extends StatelessWidget {
  CustomArticleCreationWidget({
    super.key,
  });

  String articleName = "";
  double articlePricePerUnit = 0.0;
  double articleAmount = 0.0;

  TextEditingController articleNameController = TextEditingController();
  TextEditingController articlePricePerUnitController = TextEditingController();
  TextEditingController articleAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 250,
          child: Text(
            "Benutzerdefinierter Artikel",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        MintYTextLine(
          hintText: "Artikelbeschreibung",
          width: 300,
          onChanged: (p0) {
            articleName = p0;
          },
          controller: articleNameController,
        ),
        MintYTextLine(
          hintText: "Preis pro Einheit",
          width: 200,
          onChanged: (p0) {
            articlePricePerUnit = parseDouble(p0);
          },
          controller: articlePricePerUnitController,
        ),
        MintYTextLine(
          hintText: "Menge",
          width: 100,
          onChanged: (p0) {
            articleAmount = parseDouble(p0);
          },
          controller: articleAmountController,
        ),
        Container(
          child: MintYButton(
            text: Text(
              "Hinzufügen",
              style: MintY.heading4White,
            ),
            color: MintY.currentColor,
            onPressed: () {
              // if amount or pricer per unit is zero or name is empty, do not add
              if (articleAmount == 0.0 ||
                  articlePricePerUnit == 0.0 ||
                  articleName == "") {
                return;
              }
              InvoiceService.invoiceElements.add(InvoiceElement(
                  type: InvoiceElementType.article,
                  name: articleName,
                  amount: articleAmount,
                  pricePerUnit: articlePricePerUnit));
              articleNameController.clear();
              articlePricePerUnitController.clear();
              articleAmountController.clear();

              // update the invoice element table widget
              final state = invoiceElementTableWidgetKey.currentState;
              if (state != null) {
                state.update();
              }
            },
          ),
        ),
      ],
    );
  }
}

class AdressWidget extends StatelessWidget {
  const AdressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      children: [
        MintYTextLine(
          hintText: "Firma",
          onChanged: (p0) {
            InvoiceService.currentCompanyName = p0;
          },
        ),
        MintYTextLine(
          hintText: "Ansprechpartner",
          onChanged: (p0) {
            InvoiceService.currentContactPerson = p0;
          },
        ),
        MintYTextLine(
          hintText: "Straße, Hausnummer",
          onChanged: (p0) {
            InvoiceService.currentCustomerStreet = p0;
          },
        ),
        Row(
          children: [
            MintYTextLine(
              hintText: "PLZ",
              width: 80,
              onChanged: (p0) {
                InvoiceService.currentCustomerZip = p0;
              },
            ),
            MintYTextLine(
              hintText: "Ort",
              width: 220,
              onChanged: (p0) {
                InvoiceService.currentCustomerCity = p0;
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            MintYButton(
              text: Text(
                "Laden",
                style: MintY.heading4White,
              ),
              color: MintY.currentColor,
            ),
            SizedBox(
              width: 10,
            ),
            MintYButton(
              text: Text(
                "Speichern",
                style: MintY.heading4White,
              ),
              color: MintY.currentColor,
            ),
          ],
        )
      ],
    );
  }
}
