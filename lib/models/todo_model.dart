import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  late String content;
  late String todoId;
  late Timestamp dateCreated;
  late bool done;

  Todo(
      {required this.content,
      required this.todoId,
      required this.dateCreated,
      this.done = false});

  Todo.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    todoId = documentSnapshot.reference.id;
    content = documentSnapshot['content'];
    dateCreated = documentSnapshot['dateCreated'];
    done = documentSnapshot['done'];
  }
}
