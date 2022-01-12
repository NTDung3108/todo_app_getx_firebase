// ignore_for_file: unnecessary_null_comparison, duplicate_ignore

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx_firebase/controllers.dart/auth_controller.dart';
import 'package:todo_app_getx_firebase/controllers.dart/todo_controller.dart';
import 'package:todo_app_getx_firebase/controllers.dart/user_controller.dart';
import 'package:todo_app_getx_firebase/services/database.dart';
import 'package:todo_app_getx_firebase/widget/todo_card.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController addTodoController = TextEditingController();
  AuthController authController = AuthController.instance;
  final userController = Get.put(UserController());
  final todoController = Get.put(TodoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<UserController>(
          initState: (_) async {
            Get.find<UserController>().user =
                await Database().getUser(Get.find<AuthController>().user!.uid);
          },
          builder: (_) {
            if (_.user.name != null) {
              return Text("Welcome " + _.user.name);
            } else {
              return const Text("loading...");
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              authController.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (Get.isDarkMode) {
                Get.changeTheme(ThemeData.light());
              } else {
                Get.changeTheme(ThemeData.dark());
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Add Todo Here:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: addTodoController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (addTodoController.text != '') {
                        Database().addTodo(addTodoController.text.trim(),
                            authController.user!.uid);
                        addTodoController.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          const Text(
            'Your Todo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GetX<TodoController>(
            builder: (TodoController todoController) {
              if (todoController != null && todoController.todos != null) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: todoController.todos.length,
                      itemBuilder: (_, index) {
                        return TodoCard(
                            uid: authController.user!.uid,
                            todo: todoController.todos[index]);
                      }),
                );
              } else {
                return const Text('loading....');
              }
            },
          )
        ],
      ),
    );
  }
}
