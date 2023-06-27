import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:invoice/datatypes/article.dart';
import 'package:invoice/datatypes/invoice_element.dart';
import 'package:invoice/pages/loading_screen.dart';
import 'package:invoice/pages/template_settings/template_settings.dart';
import 'package:invoice/services/article_service.dart';
import 'package:invoice/services/helpers.dart';
import 'package:invoice/services/invoice_service.dart';
import 'package:invoice/widgets/customer_widget.dart';
import 'package:invoice/widgets/mint_y.dart';

GlobalKey<InvoiceElementTableWidgetState> invoiceElementTableWidgetKey =
    GlobalKey();

class InvoiceCreationPage extends StatelessWidget {
  const InvoiceCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    invoiceElementTableWidgetKey = GlobalKey();
    return MintYPage(
      title: "Rechnung erstellen",
      centerContentElements: false,
      contentElements: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3 - 20,
              child: Text(
                "Kundenanschrift",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7 - 20,
              child: Text(
                "Position hinzufügen",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3 - 20,
              child: CustomerWidget(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7 - 20,
              child: InvoiceElementCreationWidget(),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7 - 20,
          child: Text(
            "Positionen",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InvoiceElementTableWidget(key: invoiceElementTableWidgetKey),
        // const InvoiceElementTableWidget(),
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MintYButton(
                  text: Text(
                    "Rechnungs-Ordner öffnen",
                    style: MintY.heading4White,
                  ),
                  color: MintY.currentColor,
                  onPressed: () {
                    Process.run("xdg-open", ["${getInvoicesDirectory()}"]);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              MintYButton(
                height: 50,
                text: Text(
                  "Vorschau",
                  style: MintY.heading3,
                ),
                color: MintY.grey,
                onPressed: () => InvoiceService.generateInvoice(
                    preview: true, context: context),
              ),
              SizedBox(
                width: 10,
              ),
              MintYButton(
                  height: 50,
                  text: const Text(
                    "Erstellen",
                    style: MintY.heading3White,
                  ),
                  color: MintY.currentColor,
                  onPressed: () => {
                        InvoiceService.generateInvoice(context: context),
                      }),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MintYButtonNavigate(
                    route: TemplateSettingsPage(),
                    text:
                        const Text("Einstellungen", style: MintY.heading4White),
                    color: MintY.currentColor),
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
    if (InvoiceService.invoiceElements.isEmpty) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: SizedBox(
            // Width: screensize - 200
            width: MediaQuery.of(context).size.width - 40,
            height: InvoiceService.invoiceElements.length * 100,
            child: ListView.builder(
                itemCount: InvoiceService.invoiceElements.length,
                itemBuilder: (context, index) {
                  InvoiceElement invoiceElement =
                      InvoiceService.invoiceElements[index];
                  // If invoice Element is an article calculate the price
                  if (invoiceElement.type == InvoiceElementType.article) {
                    invoiceElement.price =
                        invoiceElement.amount * invoiceElement.pricePerUnit;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      height: 50,
                      // color: Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: min(
                                MediaQuery.of(context).size.width * 0.4 - 100,
                                600),
                            child: Text(
                              invoiceElement.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              invoiceElement.type == InvoiceElementType.article
                                  ? '${InvoiceService.invoiceElements[index].amount}'
                                  : '',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              invoiceElement.type == InvoiceElementType.discount
                                  ? "-${invoiceElement.price} €"
                                  : "${invoiceElement.price} €",
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: MintYButton(
                              text: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              color: Colors.red,
                              onPressed: () {
                                InvoiceService.deleteInvoiceElement(
                                    InvoiceService.invoiceElements[index].id);
                                update();
                              },
                            ),
                          )
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
        ArticleCreationWidget(),
        SizedBox(
          height: 10,
        ),
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
        Expanded(
          child: MintYTextField(
            hintText: "Rabattbeschreibung",
            width: 400,
            onChanged: (value) {
              discountName = value;
            },
            controller: discountNameController,
          ),
        ),
        MintYTextField(
          hintText: "Preisnachlass in €",
          width: 200,
          onChanged: (value) {
            discountPrice = parseDouble(value);
          },
          controller: discountPriceController,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: MintYButton(
            text: Icon(
              Icons.add,
              color: Colors.white,
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
        Expanded(
          child: MintYTextField(
            hintText: "Aufwendungsbeschreibung",
            width: 500,
            onChanged: (p0) => {
              expenseName = p0,
            },
            controller: expenseNameController,
          ),
        ),
        MintYTextField(
          hintText: "Preis",
          width: 100,
          onChanged: (p0) => {
            expensePrice = parseDouble(p0),
          },
          controller: expensePriceController,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: MintYButton(
            text: Icon(
              Icons.add,
              color: Colors.white,
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
                  price: expensePrice,
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

class ArticleCreationWidget extends StatelessWidget {
  ArticleCreationWidget({
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
            "Artikel",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MintYTextField(
                      hintText: "Artikelbeschreibung",
                      width: 300,
                      onChanged: (p0) {
                        articleName = p0;
                      },
                      controller: articleNameController,
                    ),
                  ),
                  MintYTextField(
                    hintText: "Preis pro Einheit",
                    width: 200,
                    onChanged: (p0) {
                      articlePricePerUnit = parseDouble(p0);
                    },
                    controller: articlePricePerUnitController,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MintYSelectionDialogWithFilter(
                    selectionCallback: (string) {
                      Article article = ArticleService.articles.firstWhere(
                          (element) =>
                              "${element.description}, ${element.pricePerUnit}" ==
                              string);
                      articleNameController.text = article.description;
                      articleName = article.description;
                      articlePricePerUnitController.text = article.pricePerUnit;
                      articlePricePerUnit = parseDouble(article.pricePerUnit);
                      if (article.amount != "") {
                        articleAmountController.text = article.amount;
                        articleAmount = parseDouble(article.amount);
                      }
                    },
                    deleteCallback: (string) {
                      Article article = ArticleService.articles.firstWhere(
                          (element) =>
                              "${element.description}, ${element.pricePerUnit}" ==
                              string);
                      ArticleService.articles.remove(article);
                      ArticleService.save();
                    },
                    items:
                        List.generate(ArticleService.articles.length, (index) {
                      Article article = ArticleService.articles[index];
                      return "${article.description}, ${article.pricePerUnit}";
                    }),
                    buttonText: "Artikel auswählen",
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MintYButtonNavigate(
                    route: InvoiceCreationPage(),
                    text: const Text(
                      "Artikel speichern",
                      style: MintY.heading5White,
                    ),
                    color: MintY.currentColor,
                    onPressed: () {
                      if (articleName == "") {
                        return;
                      }
                      ArticleService.articles.add(Article(
                          description: articleName,
                          pricePerUnit: articlePricePerUnit.toString(),
                          amount: articleAmount.toString()));
                      ArticleService.save();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                MintYTextField(
                  hintText: "Menge",
                  width: 100,
                  onChanged: (p0) {
                    articleAmount = parseDouble(p0);
                  },
                  controller: articleAmountController,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: MintYButton(
                    text: Icon(
                      Icons.add,
                      color: Colors.white,
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
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      ],
    );
  }
}
