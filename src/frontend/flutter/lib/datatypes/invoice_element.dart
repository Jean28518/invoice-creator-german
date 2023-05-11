class InvoiceElement {
  // Identifier, count up at creation and assign it to itself
  static int idCounter = 0;
  int id = 0;

  InvoiceElementType type = InvoiceElementType.article;
  String name = '';

  /// only used by article
  double pricePerUnit = 0.0;

  /// only used by article
  double amount = 0.0;

  /// only used by expense and discount
  double price = 0.0;

  /// Constructor
  InvoiceElement({
    required this.type,
    required this.name,
    this.pricePerUnit = 0.0,
    this.amount = 0.0,
    this.price = 0.0,
  }) {
    id = idCounter++;
  }
}

enum InvoiceElementType {
  article,
  expense,
  discount,
}
