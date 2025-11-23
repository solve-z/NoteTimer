import '../../domain/model/todo_model.dart';
import '../../domain/repository/todo_repository.dart';
import '../data_source/local_storage/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource _localDataSource;

  TodoRepositoryImpl(this._localDataSource);

  @override
  Future<List<TodoModel>> getTodosByNoteId(String noteId) async {
    return await _localDataSource.getTodosByNoteId(noteId);
  }

  @override
  Future<List<TodoModel>> getTodosByDate(DateTime date) async {
    return await _localDataSource.getTodosByDate(date);
  }

  @override
  Future<List<TodoModel>> getTodosByNoteIdAndDate(String noteId, DateTime date) async {
    return await _localDataSource.getTodosByNoteIdAndDate(noteId, date);
  }

  @override
  Future<void> createTodo(TodoModel todo) async {
    return await _localDataSource.createTodo(todo);
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    return await _localDataSource.updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    return await _localDataSource.deleteTodo(todoId);
  }

  @override
  Future<void> toggleTodoCompletion(String todoId) async {
    return await _localDataSource.toggleTodoCompletion(todoId);
  }

  @override
  Future<void> moveTodoToDate(String todoId, DateTime newDate) async {
    return await _localDataSource.moveTodoToDate(todoId, newDate);
  }

  @override
  Future<void> updateTodoOrder(List<String> todoIds) async {
    return await _localDataSource.updateTodoOrder(todoIds);
  }
}