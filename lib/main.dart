import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/services/service_binding.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/loading_page.dart';
import 'controllers/authentication.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final ThemeData theme = ThemeData();
  await dotenv.load(fileName: ".env");
  ServiceBinding().dependencies();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ServiceBinding(),
      title: 'Ronary Notary',
      theme: theme.copyWith(
        primaryColor: Color(0xFFFFC700),
        colorScheme: theme.colorScheme.copyWith(
          secondary: Color(0xFF161617),
          primary: Color(0xFF161617),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
    return _authController.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          // if (snapshot.data == null) {
          //   return Auth();
          // }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(true, Container());
          } else {
            if (snapshot.hasError) {
              return ErrorPage(errorMessage: snapshot.error.toString());
            }
            if (snapshot.data == null || !snapshot.data) {
              return Auth();
            } else {
              return Start();
            }
          }
        });
  }
}
