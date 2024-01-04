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
      Article article = Article(
        description: lineSplit[0],
        pricePerUnit: lineSplit[1],
        amount: lineSplit[2],
      );
      articles.add(article);
    }
  }

  static void save() {
    // save articles to .csv file in config folder
    File articleFile = File("${getInvoicesDirectory()}/data/articles.csv");
    List<String> lines = ["description;pricePerUnit;amount"];
    for (Article article in articles) {
      lines.add(
          '${article.description};${article.pricePerUnit};${article.amount}');
    }
    articleFile.writeAsStringSync(lines.join("\n"));
  }
}
