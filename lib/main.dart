import 'dart:core';
import 'package:NewsApp/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'components/newsfeedListTile.dart';
import 'model/article_model.dart';
import 'services/networking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Networking network = Networking();
  String search, apiKey;

  bool isDarkMode = false;

  DateTime startTime;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    return MaterialApp(
        theme: theme,
        home: Scaffold(
          appBar: AppBar(
            title: Image.asset(
            'asset/image/newsicon.png',
            fit: BoxFit.contain,
            height: 20,
            alignment: FractionalOffset.center,
          ),
            backgroundColor: theme.primaryColor,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.brightness_4,
                  color: Colors.white,
                ),
                onPressed: toggleDarkMode,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: network.getArticle(search),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Article>> snapshot) {
                    if (snapshot.hasData) {
                      List<Article> articles = snapshot.data;
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) =>
                            newsfeedListTile(articles[index], context),
                      );
                    } else if (snapshot.hasError) {
                      return StatusCodeDisplay(statCode: network.statCode);
                    }
                    return SpinKitFadingCube(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.grey : Colors.grey,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Read time: ${DateTime.now().difference(startTime).inMinutes} mins',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
