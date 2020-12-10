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

const int nRepositories = 20;
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
            ? 'stars:>20000 sort:stars language:$language'
            : 'stars:>20000 sort:stars';
      }
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
      }
    }
    },
  }
      """;

    return Scaffold(
      appBar: AppBar(
        title: Text("Github with GraphQL"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          documentNode: gql(readRepositories),
          variables: {
            'nRepositories': 10,
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
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.blue.shade200),
                                    child: DropdownButton<String>(
                                      value: language,
                                      icon: KoukiconsExpand(
                                        color: Colors.white,
                                        height: 20,
                                      ),
                                      iconSize: .00005,
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
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.blue.shade200),
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
                                      items: <String>[
                                        'forks',
                                        'stars',
                                        // 'Commits',
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
                                children: <Widget>[
                                  Text(
                                    nRepositories.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Repositories shown",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  )
                                ],
                              )
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
                        const EdgeInsets.only(top: 10.0, bottom: 2, left: 10),
                    child: Text(
                      "Highest ranked starred repositories with $language",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                  Icon(Icons.collections_bookmark),
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
                                      Text('Commits: ' +
                                          repository['commitComments']
                                                  ['totalCount']
                                              .toString()),
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
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:koukicons/Collect.dart';
// import 'package:koukicons/parallelTasks.dart';
// import 'package:koukicons/star.dart';
//
// void main() => runApp(MaterialApp(
//     title: "Github with GraphQL",
//     debugShowCheckedModeBanner: false,
//     home: MyApp()));
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String personal_access_token = "43b3b459d8e6e090953fb39013381317a40b5f63";
//
//   @override
//   Widget build(BuildContext context) {
//     final HttpLink httpLink = HttpLink(
//         uri: 'https://api.github.com/graphql',
//         headers: {"authorization": "Bearer $personal_access_token"});
//     ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
//         GraphQLClient(
//             link: httpLink,
//             cache:
//                 OptimisticCache(dataIdFromObject: typenameDataIdFromObject)));
//     return GraphQLProvider(
//       client: client,
//       child: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// String readRepositories = """
//   query readRepositories(\$nRepositories: Int!, \$query: String!){
//     search(query: \$query, type: REPOSITORY, last: \$nRepositories) {
//       nodes {
//         ... on Repository {
//           id
//           name
//           description
//           forkCount
//
//           owner {
//             login
//           }
//           commitComments {
//             totalCount
//           }
//            stargazers {
//             totalCount
//           }
//           licenseInfo {
//             name
//           }
//         }
//       }
//     }
//   }
//   """;
//
// class _MyHomePageState extends State<MyHomePage> {
//   String userName = "";
//   String codeLanguage = "C++";
//   String sortStars = 'stars:>10000 sort:stars';
//
//   void changeQuery(String language) {
//     setState(() {
//       codeLanguage = language;
//       sortStars = language != "C++"
//           ? 'stars:>10000 sort:stars language:$language'
//           : 'stars:>10000 sort:stars';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Lab 3 - GraphQL"),
//         backgroundColor: Colors.pink,
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topCenter,
//             child: DropdownButton<String>(
//               value: codeLanguage,
//               icon: Icon(Icons.arrow_downward),
//               iconSize: 24,
//               elevation: 16,
//               style: TextStyle(color: Colors.deepPurple),
//               underline: Container(
//                 height: 2,
//                 color: Colors.deepPurpleAccent,
//               ),
//               onChanged: (String newValue) {
//                 changeQuery(newValue);
//               },
//               items: <String>['C++', 'Java', 'Python', 'HTML']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 60),
//             color: Colors.lightBlue[100],
//             child: Query(
//               options: QueryOptions(
//                 documentNode: gql(readRepositories),
//                 variables: {
//                   'nRepositories': 20,
//                   'query': sortStars,
//                 },
//                 pollInterval: 10,
//               ),
//               builder: (QueryResult result,
//                   {VoidCallback refetch, FetchMore fetchMore}) {
//                 if (result.hasException) {
//                   return Text(result.exception.toString());
//                 }
//
//                 if (result.loading) {
//                   return Text('Loading');
//                 }
//
//                 List repositories = result.data['search']['nodes'];
//
//                 return ListView.builder(
//                   physics: ClampingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: repositories.length,
//                   itemBuilder: (context, index) {
//                     final repository = repositories[index];
//
//                     return GestureDetector(
//                       child: Hero(
//                         tag: 'flutterLogo${index}',
//
//                         //behövs för att kunna trycka på en container
//                         child: InkWell(
//                           child: Container(
//                             margin:
//                                 EdgeInsets.only(top: 10, right: 10, left: 10),
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20.0)),
//                               color: Colors.lightBlue[200],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       right: 10, left: 10, bottom: 5, top: 10),
//                                   child: Text(
//                                     repository['name'],
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blueGrey,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       right: 10, left: 10, bottom: 5, top: 10),
//                                   child: Text(
//                                     repository['description'],
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.blueGrey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     fullscreenDialog: true,
//                                     builder: (_) {
//                                       return DetailScreen(
//                                           name: repository['name'],
//                                           description:
//                                               repository['description'],
//                                           forkCount: repository['forkCount']
//                                               .toString(),
//                                           stars: repository['stargazers']
//                                                   ['totalCount']
//                                               .toString(),
//                                           commits: repository['commitComments']
//                                                   ['totalCount']
//                                               .toString());
//                                     }));
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DetailScreen extends StatefulWidget {
//   final String heroTag;
//   final String name;
//   final String description;
//   final String stars;
//   final String forkCount;
//   final String commits;
//
//   DetailScreen(
//       {Key key,
//       this.name,
//       this.description,
//       this.stars,
//       this.forkCount,
//       this.commits,
//       this.heroTag})
//       : super(key: key);
//
//   @override
//   _DetailScreen createState() => _DetailScreen();
// }
//
// class _DetailScreen extends State<DetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue[100],
//       body: GestureDetector(
//         child: Hero(
//           tag: 'flutterLogo',
//
//           //behövs för att kunna trycka på en container
//           child: InkWell(
//             child: Container(
//               //alignment: Alignment.center,
//               margin: EdgeInsets.only(top: 80, left: 40, bottom: 80, right: 40),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                 color: Colors.lightBlue[200],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(
//                         right: 10, left: 10, bottom: 5, top: 10),
//                     child: Text(
//                       widget.name,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueGrey,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         right: 10, left: 10, bottom: 5, top: 10),
//                     child: Text(
//                       widget.description,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.blueGrey,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RotatedBox(
//                           quarterTurns: 3,
//                           child:
//                               KoukiconsStar(width: 15.0, color: Colors.pink)),
//                       Flexible(
//                         child: Text(
//                           " Stars: " + widget.stars.toString(),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RotatedBox(
//                           quarterTurns: 3,
//                           child: KoukiconsParallelTasks(
//                               width: 15.0, color: Colors.pink)),
//                       Flexible(
//                         child: Text(
//                           " Forks: " + widget.forkCount.toString(),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RotatedBox(
//                           quarterTurns: 3,
//                           child: KoukiconsCollect(
//                               width: 15.0, color: Colors.pink)),
//                       Flexible(
//                         child: Text(
//                           " Commits: " + widget.commits.toString(),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         onTap: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }
// }
