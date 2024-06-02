import 'package:flutter/material.dart';
import 'package:todo/components/todo_item.dart';
import 'package:todo/service/database.dart';

class AppProvider extends ChangeNotifier {
  // AppProvider provider = Provider.of<AppProvider>(context);
  // Consumer<AppProvider>(builder: (context, provider, child) => Widget);
  List<TodoItem> allTodos = [];
  List<TodoItem> required = [];
  List<TodoItem> outOfDeadline = [];

  int currentIndex = 0;

  void changeCurrentIndex(int idx) {
    currentIndex = idx;

    switch (currentIndex) {
      case 0:
        required = allTodos;
        break;
      case 2:
        required = allTodos.where((todo) => todo.completed == true).toList();
        break;
      case 3:
        required = allTodos.where((todo) => todo.completed == false).toList();
        break;
      case 4:
        required = outOfDeadline;
        break;
    }

    notifyListeners();
  }

  Future<void> getTodosFromDB() async {
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
        completed: todo["Completed"],
      );
    }).toList());

    DateTime parseDate(String date) => DateTime.parse(date);

    // print(DateTime.parse('${DateTime.now().toLocal()}'.split(' ')[0]));

    allTodos.sort((a, b) {
      DateTime dateA = DateTime.parse(a.date);
      DateTime dateB = DateTime.parse(b.date);
      return dateA.compareTo(dateB);
    });

    outOfDeadline = allTodos
        .where((todo) =>
            parseDate(todo.date).compareTo(
                parseDate('${DateTime.now().toLocal()}'.split(' ')[0])) <
            0)
        .toList();

    allTodos = allTodos
        .where((todo) =>
            parseDate(todo.date).compareTo(
                parseDate('${DateTime.now().toLocal()}'.split(' ')[0])) >=
            0)
        .toList();

    switch (currentIndex) {
      case 0:
        required = allTodos;
        break;
      case 2:
        required = allTodos.where((todo) => todo.completed == true).toList();
        break;
      case 3:
        required = allTodos.where((todo) => todo.completed == false).toList();
        break;
    }

    notifyListeners();
  }

  Future<void> update(String id, Map<String, dynamic> todoMap) async {
    await DatabaseMethods().updateTodo(id, todoMap);
    await getTodosFromDB();
  }

  Future<void> add(String id, Map<String, dynamic> todoMap) async {
    await DatabaseMethods().addTodo(todoMap, id);
    await getTodosFromDB();
  }

  Future<void> delete(String id) async {
    await DatabaseMethods().deleteTodo(id);
    await getTodosFromDB();
  }

  // List<TodoItem> getTodos() {
  //   return allTodos;
  // }

  // TodoItem getTodo(int index) {
  //   return allTodos[index];
  // }
}
