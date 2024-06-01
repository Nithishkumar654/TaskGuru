import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/todo_item.dart';
import 'package:todo/provider/app_provider.dart';

class TodoTile extends StatefulWidget {
  final TodoItem todo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TodoTile(
      {super.key,
      required this.todo,
      required this.onDelete,
      required this.onEdit});

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  bool updating = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            // width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: updating
                      ? Container(
                          width: 10,
                          height: 35,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 5),
                          child: CircularProgressIndicator())
                      : Checkbox(
                          value: widget.todo.completed,
                          fillColor: WidgetStatePropertyAll(
                              provider.currentIndex < 4 ? null : Colors.grey),
                          activeColor: Colors.green,
                          onChanged: provider.currentIndex < 4
                              ? (bool? value) async {
                                  if (value != null) {
                                    Map<String, dynamic> todoMap = {
                                      "Id": widget.todo.id,
                                      "Todo": widget.todo.todo,
                                      "Date": widget.todo.date,
                                      "Time": widget.todo.time,
                                      "Completed": value,
                                    };
                                    setState(() {
                                      updating = true;
                                    });
                                    await provider.update(
                                        widget.todo.id, todoMap);
                                    setState(() {
                                      updating = false;
                                    });
                                  }
                                }
                              : null),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.todo.todo,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onEdit,
                            child: Icon(Icons.edit, color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                      Text(
                        widget.todo.date,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.todo.time,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
