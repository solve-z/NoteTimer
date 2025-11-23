import '../model/todo_model.dart';

abstract class TodoRepository {
  /// 특정 노트의 할일 목록 조회
  Future<List<TodoModel>> getTodosByNoteId(String noteId);

  /// 특정 날짜의 할일 목록 조회
  Future<List<TodoModel>> getTodosByDate(DateTime date);

  /// 특정 노트의 특정 날짜 할일 목록 조회
  Future<List<TodoModel>> getTodosByNoteIdAndDate(String noteId, DateTime date);

  /// 할일 추가
  Future<void> createTodo(TodoModel todo);

  /// 할일 수정
  Future<void> updateTodo(TodoModel todo);

  /// 할일 삭제
  Future<void> deleteTodo(String todoId);

  /// 할일 완료 상태 토글
  Future<void> toggleTodoCompletion(String todoId);

  /// 할일 날짜 이동
  Future<void> moveTodoToDate(String todoId, DateTime newDate);

  /// 할일 순서 변경
  Future<void> updateTodoOrder(List<String> todoIds);
}
