import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:koukicons/clocktime.dart';
import 'package:koukicons/expand.dart';
import 'package:koukicons/share2.dart';
import 'package:koukicons/star.dart';

import 'Token.dart';

void main() => runApp(MaterialApp(
    title: "Github GraphQL", debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Title",
      home: MyHomePage(),
    );
  }
}

class _MyAppState extends State<MyApp> {
  // String personal_access_tokens = "43b3b459d8e6e090953fb39013381317a40b5f63";
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
        uri: 'https://api.github.com/graphql',
        headers: {"authorization": "Bearer $personal_access_tokens"});

    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(
            link: httpLink,
            cache:
                OptimisticCache(dataIdFromObject: typenameDataIdFromObject)));
    return GraphQLProvider(
      client: client,
      child: Container(
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return new Container();
  }
}

int nRepositories = 20;
String language = "Python";
String sortStars = 'sort:stars';
String sortStyle = "stars";

class _MyHomePageState extends State<MyHomePage> {
  void changeQuery(String newLanguage) {
    setState(() {
      String oldLanguage = language;
      language = newLanguage;
      sortStars = newLanguage != oldLanguage
          ? 'stars:>20000 sort:$sortStyle language:$language'
          : 'stars:>20000 sort:$sortStyle';
    });
  }

  void changeSorting(String newProperty) {
    setState(() {
      sortStyle = newProperty;

      if (newProperty == 'Stars') {
        sortStars = newProperty != "Stars"
            ? 'stars:>20000 sort:$sortStyle language:$language'
            : 'stars:>20000 sort:$sortStyle';
      }
    });
  }

  void changeAmount(int amt) {
    setState(() {
      nRepositories = amt;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Please note that Dart uses a notation with three quotes to make the queries.

    String readRepositories = """

    query(\$query: String!, \$nRepositories: Int!) {
       search(query: \$query, type: REPOSITORY, first: \$nRepositories) {
          nodes {
      ... on Repository {
        id
        name
        stargazerCount
        owner {
          id
          login
        }
        description
        stargazerCount
        forkCount
        
        
       commitComments {
             totalCount
           }
           object(expression: "master") {
          ... on Commit {
            history {
              totalCount
            }
          }
        }
      }
      
    }
    },
  }
      """;

    return Scaffold(
      appBar: AppBar(
        title: Text("Github Getter"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          documentNode: gql(readRepositories),
          variables: {
            'nRepositories': nRepositories,
            'query': 'language:' + '$language' ' sort:$sortStyle',
          },
          pollInterval: 10,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.exception != null) {
            return Center(
                child: Text(
              result.exception.toString(),
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ));
          }

          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }

          // it can be either Map or List
          final userDetails = result.data['user'];
          List starredRepositories = result.data['search']['nodes'];

          return Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.blueGrey,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    "Language",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white30),
                                  )),
                                  Container(
                                      child: new Theme(
                                    data: Theme.of(context)
                                        .copyWith(canvasColor: Colors.blueGrey),
                                    child: DropdownButton<String>(
                                      value: language,
                                      icon: KoukiconsExpand(
                                        color: Colors.white,
                                        height: 20,
                                      ),
                                      iconDisabledColor: Colors.black,
                                      elevation: 0,
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (String newValue) {
                                        changeQuery(newValue);
                                      },
                                      items: <String>[
                                        'C++',
                                        'Java',
                                        'Python',
                                        'HTML',
                                        'MATLAB'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 20),
                                    child: Container(
                                        child: Text(
                                      "Sort by",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white30),
                                    )),
                                  ),
                                  Container(
                                      child: new Theme(
                                    data: Theme.of(context)
                                        .copyWith(canvasColor: Colors.blueGrey),
                                    child: DropdownButton<String>(
                                      value: sortStyle,
                                      icon: KoukiconsExpand(
                                        color: Colors.white,
                                        height: 20,
                                      ),
                                      iconSize: .00005,
                                      iconDisabledColor: Colors.black,
                                      elevation: 0,
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (String newValue) {
                                        changeSorting(newValue);
                                      },
                                      items: <String>['stars', 'forks']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 20),
                                    child: Container(
                                        child: Text(
                                      "Repos",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white30),
                                    )),
                                  ),
                                  Container(
                                      child: new Theme(
                                    data: Theme.of(context)
                                        .copyWith(canvasColor: Colors.blueGrey),
                                    child: DropdownButton<int>(
                                      value: nRepositories,
                                      icon: KoukiconsExpand(
                                        color: Colors.white,
                                        height: 20,
                                      ),
                                      iconSize: .00005,
                                      iconDisabledColor: Colors.black,
                                      elevation: 0,
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (int newValue) {
                                        changeAmount(newValue);
                                      },
                                      items: <int>[
                                        2,
                                        10,
                                        20,
                                        30,
                                        // 'Commits',
                                      ].map<DropdownMenuItem<int>>((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(value.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, bottom: 2, left: 20),
                    child: Text(
                      "Highest ranked $language repositories sorted by $sortStyle",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: ListView.builder(
                  itemCount: starredRepositories.length,
                  itemBuilder: (context, index) {
                    final repository = starredRepositories[index];

                    final commits = repository['commitComments']['totalCount'];

                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 8, bottom: 8),
                      child: Card(
                        elevation: 0,
                        child: Row(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 5,
                                    height: 100,
                                  ),
                                  Icon(Icons.laptop_chromebook_sharp),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      repository['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              // Container(
                              //   child: Text(repository['description'],
                              //       style: TextStyle(
                              //           fontSize: 10,
                              //           fontWeight: FontWeight.w500)),
                              // )
                            ]),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      KoukiconsStar(
                                        height: 15,
                                      ),
                                      Text('Stars: ' +
                                          repository['stargazerCount']
                                              .toString()),
                                    ]),
                                    Row(
                                      children: <Widget>[
                                        Transform.rotate(
                                          angle: -pi / 2,
                                          child: KoukiconsShare2(
                                            height: 15,
                                          ),
                                        ),
                                        Text('Forks: ' +
                                            repository['forkCount'].toString())
                                      ],
                                    ),
                                    Row(children: <Widget>[
                                      KoukiconsClocktime(
                                        height: 15,
                                      ),
                                      Text('Commits: ' + commits.toString()),
                                    ]),
                                  ],

                                  // child: Text(
                                  //   '',
                                  //
                                  // )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
