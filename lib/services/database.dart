import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({required this.firestore});

  Stream<List<TodoModel>> streamTodos({required String uid}) {
    try {
      return firestore
          .collection("allUserTodos")
          .doc(uid)
          .collection("todos")
          .where("done", isEqualTo: false)
          .snapshots()
          .map((query) {
        List<TodoModel> todoList = [];
        for (final DocumentSnapshot doc in query.docs) {
          todoList.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return todoList;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo({required String uid, required String content}) async {
    try {
      firestore
          .collection("allUserTodos")
          .doc(uid)
          .collection("todos")
          .add({"content": content, "done": false});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo({required String uid, required String todoId}) async {
    try {
      firestore
          .collection("allUserTodos")
          .doc(uid)
          .collection("todos")
          .doc(todoId)
          .update({"done": true});
    } catch (e) {
      rethrow;
    }
  }
}
