import 'package:get/get.dart';
import 'package:todo_app_getx_firebase/controllers.dart/auth_controller.dart';
import 'package:todo_app_getx_firebase/models/todo_model.dart';
import 'package:todo_app_getx_firebase/services/database.dart';

class TodoController extends GetxController {
  Rx<List<Todo>> todoList = Rx<List<Todo>>([]);

  List<Todo> get todos => todoList.value;

  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    todoList.bindStream(Database().todoStream(uid));
  }
}
