import 'dart:io';

import 'package:invoice/models/article.dart';
import 'package:invoice/services/helpers.dart';

// CSV: template: description;pricePerUnit;amount

class ArticleService {
  static List<Article> articles = [];

  static void init() {
    // load and parse .csv file from config folder
    File articleFile = File("${getInvoicesDirectory()}/data/articles.csv");
    if (!articleFile.existsSync()) {
      articleFile.createSync(recursive: true);
    }
    List<String> lines = articleFile.readAsLinesSync();
    for (int i = 1; i < lines.length; i++) {
      String line = lines[i];
      List<String> lineSplit = line.split(";");
      while (lineSplit.length < 4) {
        lineSplit.add("");
      }
      Article article = Article(
        description: lineSplit[0],
        pricePerUnit: lineSplit[1],
        amount: lineSplit[2],
        summary: lineSplit[3].replaceAll("<br>", "\n"),
        brutto: lineSplit.length > 4 ? lineSplit[4] == "true" : false,
      );
      articles.add(article);
    }
  }

  static void save() {
    // save articles to .csv file in config folder
    File articleFile = File("${getInvoicesDirectory()}/data/articles.csv");
    List<String> lines = ["description;pricePerUnit;amount;summary;brutto"];
    for (Article article in articles) {
      lines.add(
          '${article.description};${article.pricePerUnit};${article.amount};${article.summary.replaceAll("\n", "<br>").replaceAll(";", ",")};${article.brutto}');
    }
    articleFile.writeAsStringSync(lines.join("\n"));
  }
}
