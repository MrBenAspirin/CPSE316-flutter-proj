import 'dart:convert';
import 'package:NewsApp/model/article_model.dart';
import 'package:http/http.dart';

class ApiService {
  final String apiID = "77fc7fcb498f4837bda6bebb7cb033e2";

  Future<List<Article>> getArticle(String search) async {
    ;

    if (search == null) {
      try {
        Response response = await get(Uri.parse("https://newsapi.org/v2/everything?q=news&apiKey=$apiID"));
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);

          List<dynamic> body = json['articles'];

          //this line will allow us to get the different articles from the json file and putting them into a list
          List<Article> articles =
              body.map((dynamic item) => Article.fromJson(item)).toList();

          return articles;
        } else {
          throw Exception("Response status code is not 200");

        }
      } catch (e) {
        print(e);
        throw ("Can't get the Articles");

      }
    } else {
      try {
        Response response = await get(Uri.parse("https://newsapi.org/v2/everything?q=$search&apiKey=$apiID"));
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);

          List<dynamic> body = json['articles'];

          //this line will allow us to get the different articles from the json file and putting them into a list
          List<Article> articles =
              body.map((dynamic item) => Article.fromJson(item)).toList();

          return articles;
        } else {
          throw Exception("Response status code is not 200");
        }
      } catch (e) {
        print(e);
        throw ("Can't get the Articles");
      }
    }
  }
}
