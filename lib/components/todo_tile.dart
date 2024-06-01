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
  bool? completed = false;
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
                  child: CheckboxListTile.adaptive(
                      value: completed,
                      activeColor: Colors.green,
                      onChanged: (bool? value) {
                        setState(() {
                          completed = value;
                        });
                      }),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.todo.time,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 20,
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
