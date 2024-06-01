import 'package:flutter/material.dart';
import 'package:todo/components/todo_item.dart';
import 'package:todo/service/database.dart';

class AppProvider extends ChangeNotifier {
  // AppProvider provider = Provider.of<AppProvider>(context);
  int items = 0;
  static List<TodoItem> allTodos = [];

  int currentIndex = 0;

  void changeCurrentIndex(int idx) {
    currentIndex = idx;
    notifyListeners();
  }

  void getTodosFromDB() async {
    final stream = DatabaseMethods().getTodos();

    final querySnapshot = await stream.first;
    allTodos.clear();

    allTodos.addAll(querySnapshot.docs.map((doc) {
      final todo = doc.data() as Map<String, dynamic>;
      return TodoItem(
        todo: todo["Todo"],
        date: todo["Date"],
        time: todo["Time"],
        id: todo["Id"],
      );
    }).toList());

    notifyListeners();
  }

  List<TodoItem> getTodos() {
    return allTodos;
  }

  TodoItem getTodo(int index) {
    return allTodos[index];
  }
}
