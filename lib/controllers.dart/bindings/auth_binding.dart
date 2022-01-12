import 'package:get/get.dart';
import 'package:todo_app_getx_firebase/controllers.dart/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
