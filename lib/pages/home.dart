import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/_drawer.dart';
import 'package:todo/components/todo_item.dart';
import 'package:todo/components/todo_tile.dart';
import 'package:todo/pages/add_update_todo.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/service/auth_service.dart';
import 'package:todo/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController todoNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  bool isLoading = false, deleting = false;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();

    AppProvider provider = Provider.of<AppProvider>(context, listen: false);
    provider.getTodosFromDB();
  }

  Widget allTodos() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        List<TodoItem> todos = provider.required;
        if (todos.isEmpty) {
          return Center(child: Text('No Todos'));
        }
        return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              TodoItem todo = todos[index];
              TodoTile tile = TodoTile(
                  todo: todo,
                  onEdit: () =>
                      editTodo(todo.id, todo.todo, todo.date, todo.time));
              return tile;
            });
      },
    );
  }

  void editTodo(String id, String todo, String date, String time) {
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

  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AddTodo(gotoHome: () => setState(() {
      //           provider.currentIndex = 0;
      //       }))),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TASK ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "GURU",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await _auth.signout();
                setState(() {
                  isLoading = false;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Logout ",
                    style: TextStyle(color: Colors.red),
                  ),
                  if (isLoading) ...[
                    CircularProgressIndicator(
                      color: Colors.red,
                    )
                  ],
                  if (!isLoading) ...[
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                    )
                  ]
                ],
              ))
        ],
      ),
      drawer: MyDrawer(),
      body: Consumer<AppProvider>(builder: (context, provider, _) {
        return Container(
          child: provider.currentIndex != 1
              ? Column(
                  children: [
                    Expanded(child: allTodos()),
                  ],
                )
              : AddTodo(
                  date: "",
                  id: "",
                  time: "",
                  todo: "",
                  gotoHome: () => provider.changeCurrentIndex(0)),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.currentIndex == 1 ? 1 : 0,
        onTap: (value) => provider.changeCurrentIndex(value),
        selectedLabelStyle: TextStyle(color: Colors.black),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
              label: "Add Todo",
              backgroundColor: Colors.green)
        ],
      ),
    );
  }
}
