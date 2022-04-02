import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final ThemeData theme = ThemeData();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationController()),
        ChangeNotifierProvider(create: (context) => JournalController()),
        ChangeNotifierProvider(create: (context) => PaymentController()),
        ChangeNotifierProvider(create: (context) => PlanController()),
        ChangeNotifierProvider(create: (context) => PointController()),
        ChangeNotifierProvider(create: (context) => RecipientController()),
        ChangeNotifierProvider(create: (context) => SessionController()),
        ChangeNotifierProvider(create: (context) => SupportController()),
        ChangeNotifierProvider(create: (context) => UserController()),
      ],
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
