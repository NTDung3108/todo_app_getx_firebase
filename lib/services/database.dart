import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_getx_firebase/models/todo_model.dart';
import 'package:todo_app_getx_firebase/models/user.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return UserModel.fromDocumentSnapshot(doc);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      rethrow;
    }
  }

  Future<void> addTodo(String content, String uid) async {
    try {
      await _firestore.collection('users').doc(uid).collection('todos').add(
          {'dateCreated': Timestamp.now(), 'content': content, 'done': false});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<Todo>> todoStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('todos')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Todo> retVel = [];
      query.docs.forEach((element) {
        retVel.add(Todo.fromDocumentSnapshot(element));
      });
      return retVel;
    });
  }

  Future<void> updateTodo(bool newVlaue, String uid, String todoId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({'done': newVlaue});
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
