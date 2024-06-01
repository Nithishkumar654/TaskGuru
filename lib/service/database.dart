import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addTodo(Map<String, dynamic> todoMap, String id) async {
    try {
      await FirebaseFirestore.instance.collection("todos").doc(id).set(todoMap);
    } catch (e) {
      print('Error while adding: $e');
      throw e;
    }
  }

  Stream<QuerySnapshot> getTodos() {
    return FirebaseFirestore.instance.collection("todos").snapshots();
  }

  Future updateTodo(String id, Map<String, dynamic> updateTodo) async {
    return await FirebaseFirestore.instance
        .collection("todos")
        .doc(id)
        .update(updateTodo);
  }

  Future deleteTodo(String id) async {
    return await FirebaseFirestore.instance
        .collection("todos")
        .doc(id)
        .delete();
  }
}
