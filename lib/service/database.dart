import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  final _auth = FirebaseAuth.instance;

  Future<void> addTodo(Map<String, dynamic> todoMap, String id) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("todos")
            .doc(id)
            .set(todoMap);
      }
    } catch (e) {
      print('Error while adding: $e');
      throw e;
    }
  }

  Stream<QuerySnapshot> getTodos() {
    final user = _auth.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection("todos")
          .snapshots();
    }
    return Stream.empty();
  }

  Future updateTodo(String id, Map<String, dynamic> updateTodo) async {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        return await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("todos")
            .doc(id)
            .update(updateTodo);
      }
    } catch (e) {
      print('Error while updating: $e');
      throw e;
    }
  }

  Future deleteTodo(String id) async {
    final user = _auth.currentUser;

    try {
      if (user != null) {
        return await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("todos")
            .doc(id)
            .delete();
      }
    } catch (e) {
      print('Error while deleting: $e');
      throw e;
    }
  }
}
