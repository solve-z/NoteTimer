import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../domain/model/todo_model.dart';
import '../../../../domain/model/note_model.dart';
import 'todo_item.dart';

class TodoListView extends StatelessWidget {
  final List<TodoModel> todos;
  final NoteModel? note;
  final Function(String todoId)? onToggle;
  final Function(String todoId)? onDelete;
  final Function(String todoId, String newTitle)? onEdit;
  final Function(String todoId, DateTime date)? onMove;

  const TodoListView({
    super.key,
    required this.todos,
    this.note,
    this.onToggle,
    this.onDelete,
    this.onEdit,
    this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(
        child: Text(
          '할일이 없습니다',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    // 날짜별로 그룹화
    final groupedTodos = _groupByDate(todos);
    final sortedDates = groupedTodos.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 최신순

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final todosForDate = groupedTodos[date]!;
        final dateStr = DateFormat('yyyy/MM/dd').format(date);
        final hasOverdueTodo = _hasOverdueTodo(todosForDate, date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 헤더
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                dateStr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: hasOverdueTodo ? Colors.red : Colors.black,
                ),
              ),
            ),
            // 할일 리스트
            ...todosForDate.map((todo) => TodoItem(
                  todo: todo,
                  isArchived: note?.isArchived ?? false,
                  onToggle: () => onToggle?.call(todo.id),
                  onDelete: () => onDelete?.call(todo.id),
                  onEdit: (newTitle) => onEdit?.call(todo.id, newTitle),
                  onMove: (newDate) => onMove?.call(todo.id, newDate),
                )),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  Map<DateTime, List<TodoModel>> _groupByDate(List<TodoModel> todos) {
    final Map<DateTime, List<TodoModel>> grouped = {};

    for (final todo in todos) {
      final date = DateTime(
        todo.assignedDate.year,
        todo.assignedDate.month,
        todo.assignedDate.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(todo);
    }

    // 각 날짜 내에서 sortOrder로 정렬
    grouped.forEach((key, value) {
      value.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    });

    return grouped;
  }

  bool _hasOverdueTodo(List<TodoModel> todos, DateTime date) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // 지난 날짜이고 미완료 할일이 있는지 확인
    if (date.isBefore(todayDate)) {
      return todos.any((todo) => !todo.isCompleted);
    }

    return false;
  }
}
