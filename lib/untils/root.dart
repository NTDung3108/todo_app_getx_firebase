import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx_firebase/controllers.dart/auth_controller.dart';
import 'package:todo_app_getx_firebase/controllers.dart/user_controller.dart';
import 'package:todo_app_getx_firebase/screens/home_screen.dart';
import 'package:todo_app_getx_firebase/screens/login_screen.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      // initState: (_) async {
      //   Get.put(UserController());
      // },
      builder: (_) {
        if (Get.find<AuthController>().user?.uid != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
