import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/home.dart';

import 'controllers/authentication.dart';

void main() async {
  await GetStorage.init();
  final ThemeData theme = ThemeData();
  await dotenv.load(fileName: ".env");
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ronary Notary',
      theme: theme.copyWith(
        primaryColor: Color(0xFFFFC700),
        colorScheme: theme.colorScheme.copyWith(
          secondary: Color(0xFF161617),
          primary: Color(0xFF161617),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: Color(0xFF161617),
        canvasColor: Colors.white,
        backgroundColor: Color(0xFFFFFFFF),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
      ),
      home: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final AuthenticationController _authController =
      Get.put(AuthenticationController());

  Future<void> initializeSettings() async {
    // _authController.logOut();
    return _authController.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          print("snapshot.data ${snapshot.data}");
          // if (snapshot.data == null) {
          //   return Auth();
          // }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          } else {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.data == null || !snapshot.data) {
              return Auth();
            } else {
              return HomePage();
            }
          }
        });
  }
}
