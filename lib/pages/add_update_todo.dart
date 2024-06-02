import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/service/database.dart';

class AddTodo extends StatefulWidget {
  final VoidCallback gotoHome;
  final String todo, date, time, id;
  const AddTodo(
      {super.key,
      required this.gotoHome,
      required this.id,
      required this.todo,
      required this.date,
      required this.time});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController todoNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool update = false;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      todoNameController.text = widget.todo;
      timeController.text = widget.time;
      dateController.text = widget.date;
    });
    if (widget.todo.isNotEmpty) {
      setState(() {
        update = true;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime != null) {
      setState(() {
        timeController.text = selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              update ? "Edit " : "Add ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Todo",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<AppProvider>(builder: (context, provider, _) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Todo",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: todoNameController,
                    hintText: "Enter Todo",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a todo';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Select Deadline Date",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDateField(
                    context: context,
                    controller: dateController,
                    hintText: "Select Date",
                    suffixIcon: Icon(Icons.calendar_today_rounded),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Select Deadline Time",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDateField(
                    context: context,
                    controller: timeController,
                    hintText: "Select Time",
                    onTap: () => _selectTime(context),
                    suffixIcon: Icon(Icons.timer_sharp),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              saving ? Colors.grey : Colors.green)),
                      onPressed: saving
                          ? null
                          : () async {
                              todoNameController.text =
                                  todoNameController.text.trim();
                              if (_formKey.currentState!.validate()) {
                                String id = randomAlphaNumeric(10);
                                Map<String, dynamic> todoMap = {
                                  "Id": update ? widget.id : id,
                                  "Todo": todoNameController.text,
                                  "Date": dateController.text,
                                  "Time": timeController.text,
                                  "Completed": false,
                                };
                                try {
                                  setState(() {
                                    saving = true;
                                  });
                                  update
                                      ? await provider.update(
                                          widget.id, todoMap)
                                      : await provider.add(id, todoMap);
                                  setState(() {
                                    todoNameController.text = "";
                                    dateController.text = "";
                                    timeController.text = "";
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarAnimationStyle: AnimationStyle(
                                      duration: Duration(seconds: 1),
                                      curve: Curves.decelerate,
                                    ),
                                    SnackBar(
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      showCloseIcon: true,
                                      closeIconColor: Colors.black,
                                      backgroundColor: Colors.blue,
                                      content: Text(update
                                          ? 'Todo Updated Successfully'
                                          : 'Todo Added Successfully'),
                                    ),
                                  );
                                  update
                                      ? Navigator.pop(context)
                                      : widget.gotoHome();
                                  await Future.delayed(Duration(seconds: 1));
                                  setState(() {
                                    update = false;
                                    saving = false;
                                  });
                                } catch (e) {
                                  // Fluttertoast.showToast(
                                  //   msg: "Error: $e",
                                  //   toastLength: Toast.LENGTH_LONG,
                                  //   gravity: ToastGravity.CENTER,
                                  //   timeInSecForIosWeb: 1,
                                  //   backgroundColor: Colors.red,
                                  //   textColor: Colors.white,
                                  //   fontSize: 16.0,
                                  // );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarAnimationStyle: AnimationStyle(
                                      duration: Duration(seconds: 1),
                                      curve: Curves.decelerate,
                                    ),
                                    SnackBar(
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      showCloseIcon: true,
                                      closeIconColor: Colors.black,
                                      backgroundColor: Colors.red,
                                      content: Text('Error: $e'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarAnimationStyle: AnimationStyle(
                                    duration: Duration(seconds: 1),
                                    curve: Curves.decelerate,
                                  ),
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    showCloseIcon: true,
                                    closeIconColor: Colors.black,
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'Error: Please fill all the fields.'),
                                  ),
                                );
                              }
                            },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            update ? "Save" : "Add Todo",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          if (saving) ...[
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required Icon suffixIcon,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
        readOnly: true,
        onTap: onTap,
        validator: validator,
      ),
    );
  }
}
