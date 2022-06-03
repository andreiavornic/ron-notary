import 'dart:convert';
import 'dart:io';

// import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_apns/apns.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/loading_page.dart';
import 'controllers/authentication.dart';
import 'controllers/journal.dart';
import 'controllers/payment.dart';
import 'controllers/plan.dart';
import 'controllers/point.dart';
import 'controllers/recipient.dart';
import 'controllers/session.dart';
import 'controllers/support.dart';
import 'controllers/user.dart';
import 'firebase_options.dart';
import 'methods/show_error.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  } else {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    print(
        "debugDefaultTargetPlatformOverride $debugDefaultTargetPlatformOverride");
  }

  kNotificationSlideDuration = const Duration(milliseconds: 500);
  kNotificationDuration = const Duration(milliseconds: 1500);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final ThemeData theme = ThemeData();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationController()),
        ChangeNotifierProvider(create: (_) => JournalController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => PlanController()),
        ChangeNotifierProvider(create: (_) => PointController()),
        ChangeNotifierProvider(create: (_) => RecipientController()),
        ChangeNotifierProvider(create: (_) => SessionController()),
        ChangeNotifierProvider(create: (_) => SupportController()),
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: OverlaySupport.global(
        toastTheme: ToastThemeData(
          textColor: Color(0xFF161617),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
      ),
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with RouteAware {


  @override
  initState() {
    super.initState();
    getPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getPermission() async {
    await [
      Permission.microphone,
      Permission.camera,
      Permission.notification,
      Permission.manageExternalStorage,
    ].request();
  }

  Future<void> initializeSettings() async {
    return Provider.of<AuthenticationController>(context, listen: false)
        .checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
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
