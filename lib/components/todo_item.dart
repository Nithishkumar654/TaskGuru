class TodoItem {
  final String todo;
  final String date;
  final String time;
  final String id;
  final bool? completed;
  const TodoItem(
      {required this.todo,
      required this.date,
      required this.time,
      required this.id,
      required this.completed});
}
