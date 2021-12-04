import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/user.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    // userController.sendMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      init: UserController(),
      builder: (_userController) => Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Settings, ${userController.user.value.firstName}"),
              ElevatedButton(
                onPressed: () => null,
                child: Text("Change name"),
              ),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text("Go Back"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
