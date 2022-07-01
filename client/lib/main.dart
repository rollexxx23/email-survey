import 'dart:convert';
import 'package:client/provider/user.dart';
import 'package:client/views/add_question.dart';
import 'package:provider/provider.dart';
import 'package:client/views/dashboard.dart';
import 'package:client/views/landing-page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

bool isLoggedIn = false;
Future<bool> getCurrentUser(context) async {
  var client = BrowserClient()..withCredentials = true;
  http.Response response;
  const url = "http://localhost:5000/api/current_user";
  try {
    response = await client.get(
      Uri.parse(url),
    );
    print(response.body);
    if (response.body.toString().isEmpty) {
      return false;
    }
    var data = json.decode(response.body);
    if (data["_id"] != null) {
      Provider.of<UserWrapper>(context, listen: false)
          .updateCredits(data["credits"]);
      return true;
    }
    return false;
  } finally {
    client.close();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final bool isLoggedIn = await getCurrentUser();
  final MyApp myApp = MyApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserWrapper()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    // getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    print(isLoggedIn);
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: getCurrentUser(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data ? DashBoard() : LandingPage();
            } else {
              return Container(color: Colors.white);
            }
          },
        ));
  }
}
