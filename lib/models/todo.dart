import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String todoId;
  late String content;
  late bool done;

  TodoModel({required this.todoId, required this.content, required this.done});

  TodoModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}){
    todoId = documentSnapshot.id;
    content = documentSnapshot.data()['content'] as String;
    done = documentSnapshot.data()['done'] as bool;
  }

}
