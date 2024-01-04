import 'package:flutter/material.dart';
import 'package:invoice/models/customer.dart';
import 'package:invoice/pages/invoice_creation/invoice_creation.dart';
import 'package:invoice/services/customer_service.dart';
import 'package:invoice/services/invoice_service.dart';
import 'package:invoice/widgets/mint_y.dart';

class CustomerWidget extends StatelessWidget {
  CustomerWidget({
    super.key,
  });

  TextEditingController companyNameController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController customerStreetController = TextEditingController();
  TextEditingController customerZipController = TextEditingController();
  TextEditingController customerCityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    companyNameController.text = InvoiceService.currentCompanyName;
    contactPersonController.text = InvoiceService.currentContactPerson;
    customerStreetController.text = InvoiceService.currentCustomerStreet;
    customerZipController.text = InvoiceService.currentCustomerZip;
    customerCityController.text = InvoiceService.currentCustomerCity;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: MintYTextField(
                    hintText: "Firma (optional)",
                    onChanged: (p0) {
                      p0 = p0.replaceAll(";", "");
                      InvoiceService.currentCompanyName = p0;
                    },
                    controller: companyNameController,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MintYTextField(
                    hintText: "Ansprechpartner",
                    onChanged: (p0) {
                      p0 = p0.replaceAll(";", "");
                      InvoiceService.currentContactPerson = p0;
                    },
                    controller: contactPersonController,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MintYTextField(
                    hintText: "Straße, Hausnummer",
                    onChanged: (p0) {
                      p0 = p0.replaceAll(";", "");
                      InvoiceService.currentCustomerStreet = p0;
                    },
                    controller: customerStreetController,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                MintYTextField(
                  hintText: "PLZ",
                  width: 100,
                  onChanged: (p0) {
                    p0 = p0.replaceAll(";", "");
                    InvoiceService.currentCustomerZip = p0;
                  },
                  controller: customerZipController,
                ),
                Expanded(
                  child: MintYTextField(
                    hintText: "Ort",
                    onChanged: (p0) {
                      p0 = p0.replaceAll(";", "");
                      InvoiceService.currentCustomerCity = p0;
                    },
                    controller: customerCityController,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                MintYSelectionDialogWithFilter(
                  selectionCallback: (string) {
                    Customer customer = CustomerService.customers.firstWhere(
                        (element) =>
                            "${element.name}, ${element.city}, ${element.companyName}" ==
                            string);
                    InvoiceService.currentCompanyName = customer.companyName;
                    InvoiceService.currentContactPerson = customer.name;
                    InvoiceService.currentCustomerStreet = customer.street;
                    InvoiceService.currentCustomerZip = customer.zip;
                    InvoiceService.currentCustomerCity = customer.city;
                    companyNameController.text = customer.companyName;
                    contactPersonController.text = customer.name;
                    customerStreetController.text = customer.street;
                    customerZipController.text = customer.zip;
                    customerCityController.text = customer.city;
                  },
                  deleteCallback: (string) {
                    Customer customer = CustomerService.customers.firstWhere(
                        (element) =>
                            "${element.name}, ${element.city}, ${element.companyName}" ==
                            string);
                    CustomerService.customers.remove(customer);
                    CustomerService.save();
                  },
                  items:
                      List.generate(CustomerService.customers.length, (index) {
                    // generate string from customer.companyName and customer.name and city
                    Customer customer = CustomerService.customers[index];
                    return "${customer.name}, ${customer.city}, ${customer.companyName}";
                  }),
                  buttonText: "Kunde auswählen",
                ),
                SizedBox(
                  width: 10,
                ),
                MintYButtonNavigate(
                  route: const InvoiceCreationPage(),
                  text: Text(
                    "Speichern",
                    style: MintY.heading5White,
                  ),
                  color: MintY.currentColor,
                  onPressed: () {
                    // If everything is empty, don't save
                    if (InvoiceService.currentCompanyName == "" &&
                        InvoiceService.currentContactPerson == "" &&
                        InvoiceService.currentCustomerStreet == "" &&
                        InvoiceService.currentCustomerZip == "" &&
                        InvoiceService.currentCustomerCity == "") {
                      return;
                    }

                    Customer customer = Customer(
                      companyName: InvoiceService.currentCompanyName,
                      name: InvoiceService.currentContactPerson,
                      street: InvoiceService.currentCustomerStreet,
                      zip: InvoiceService.currentCustomerZip,
                      city: InvoiceService.currentCustomerCity,
                    );
                    CustomerService.customers.add(customer);
                    CustomerService.save();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
