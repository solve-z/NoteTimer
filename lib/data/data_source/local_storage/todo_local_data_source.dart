import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/todo_model.dart';

class TodoLocalDataSource {
  final Box<TodoModel> _todoBox;

  TodoLocalDataSource(this._todoBox);

  /// 특정 노트의 할일 목록 조회
  Future<List<TodoModel>> getTodosByNoteId(String noteId) async {
    return _todoBox.values
        .where((todo) => todo.noteId == noteId)
        .toList()
      ..sort((a, b) {
        // 날짜 내림차순 (최신순)
        final dateCompare = b.assignedDate.compareTo(a.assignedDate);
        if (dateCompare != 0) return dateCompare;
        // 같은 날짜면 sortOrder로 정렬
        return a.sortOrder.compareTo(b.sortOrder);
      });
  }

  /// 특정 날짜의 할일 목록 조회
  Future<List<TodoModel>> getTodosByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _todoBox.values
        .where((todo) =>
            todo.assignedDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            todo.assignedDate.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// 특정 노트의 특정 날짜 할일 목록 조회
  Future<List<TodoModel>> getTodosByNoteIdAndDate(String noteId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _todoBox.values
        .where((todo) =>
            todo.noteId == noteId &&
            todo.assignedDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            todo.assignedDate.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// 할일 추가
  Future<void> createTodo(TodoModel todo) async {
    await _todoBox.put(todo.id, todo);
  }

  /// 할일 수정
  Future<void> updateTodo(TodoModel todo) async {
    await _todoBox.put(todo.id, todo);
  }

  /// 할일 삭제
  Future<void> deleteTodo(String todoId) async {
    await _todoBox.delete(todoId);
  }

  /// 할일 완료 상태 토글
  Future<void> toggleTodoCompletion(String todoId) async {
    final todo = _todoBox.get(todoId);
    if (todo != null) {
      final updatedTodo = todo.copyWith(
        isCompleted: !todo.isCompleted,
        updatedAt: DateTime.now(),
      );
      await _todoBox.put(todoId, updatedTodo);
    }
  }

  /// 할일 날짜 이동
  Future<void> moveTodoToDate(String todoId, DateTime newDate) async {
    final todo = _todoBox.get(todoId);
    if (todo != null) {
      final updatedTodo = todo.copyWith(
        assignedDate: newDate,
        updatedAt: DateTime.now(),
      );
      await _todoBox.put(todoId, updatedTodo);
    }
  }

  /// 할일 순서 변경
  Future<void> updateTodoOrder(List<String> todoIds) async {
    for (int i = 0; i < todoIds.length; i++) {
      final todo = _todoBox.get(todoIds[i]);
      if (todo != null) {
        final updatedTodo = todo.copyWith(sortOrder: i);
        await _todoBox.put(todoIds[i], updatedTodo);
      }
    }
  }

  /// 모든 할일 조회
  Future<List<TodoModel>> getAllTodos() async {
    return _todoBox.values.toList();
  }
}
