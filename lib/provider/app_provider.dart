import 'package:flutter/material.dart';
import 'package:todo/components/todo_item.dart';
import 'package:todo/pages/add_update_todo.dart';
import 'package:todo/service/database.dart';

class AppProvider extends ChangeNotifier {
  // AppProvider provider = Provider.of<AppProvider>(context);
  int items = 0;

  final TextEditingController todoNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  static List<TodoItem> allTodos = [];

  int currentIndex = 0;

  void changeCurrentIndex(int idx) {
    currentIndex = idx;
    notifyListeners();
  }

  AppProvider() {
    allTodos = [];
  }

  Future<void> editTodo(BuildContext context, String id, String todo,
      String date, String time) async {
    todoNameController.text = todo;
    dateController.text = date;
    timeController.text = time;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 3 * MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width,
          child: AddTodo(
              gotoHome: () {}, id: id, todo: todo, date: date, time: time),
        ),
      ),
    );
  }

  void add(TodoItem todo) {
    allTodos.add(todo);
  }

  void getTodosFromDB(BuildContext context) async {
    final stream = DatabaseMethods().getTodos();

    // final querySnapshot = await stream.first;
    allTodos.clear();

    

    stream.listen((querySnapshot) {
      allTodos = querySnapshot.docs.map((doc) {
        final todo = doc.data() as Map<String, dynamic>;
        return TodoItem(
          todo: todo["Todo"],
          date: todo["Date"],
          time: todo["Time"],
          id: todo["Id"],
          onEdit: () => editTodo(
            context,
            todo["Id"],
            todo["Todo"],
            todo["Date"],
            todo["Time"],
          ),
          onDelete: () async {
            await DatabaseMethods().deleteTodo(todo["Id"]);
          },
        );
      }).toList();

      print('${allTodos.length} - todos');
      notifyListeners();
      print('${allTodos.length} - todos');
    });

    // final res = StreamBuilder(
    //     stream: stream,
    //     builder: (context, snapshot) {
    //       print('hi');
    //       if (snapshot.hasData) {
    //         print(snapshot.data);
    //       }
    //       return Text("");
    //       // return TodoItem(
    //       //     todo: ds["Todo"],
    //       //     date: ds["Date"],
    //       //     time: ds["Time"],
    //       //     id: ds["Id"],
    //       //     onEdit: () => editTodo(
    //       //           context,
    //       //           ds["Id"],
    //       //           ds["Todo"],
    //       //           ds["Date"],
    //       //           ds["Time"],
    //       //         ),
    //       //     onDelete: () async {
    //       //       await DatabaseMethods().deleteTodo(ds["Id"]);
    //       //     });
    //     });

    // allTodos.addAll(querySnapshot.docs.map((doc) {
    //   final todo = doc.data() as Map<String, dynamic>;
    //   return TodoItem(
    //       todo: todo["Todo"],
    //       date: todo["Date"],
    //       time: todo["Time"],
    //       id: todo["Id"],
    //       onEdit: () => editTodo(
    //             context,
    //             todo["Id"],
    //             todo["Todo"],
    //             todo["Date"],
    //             todo["Time"],
    //           ),
    //       onDelete: () async {
    //         await DatabaseMethods().deleteTodo(todo["Id"]);
    //       });
    // }).toList());

    // print(allTodos);

    // final todo = await todos.toList();
    print(1);
    print(1);
    // allTodos = todos;
  }

  List<TodoItem> getTodos() {
    return allTodos;
  }
}
