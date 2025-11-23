import '../../model/todo_model.dart';
import '../../repository/todo_repository.dart';

class GetTodosByNoteAndDateUseCase {
  final TodoRepository _repository;

  GetTodosByNoteAndDateUseCase(this._repository);

  Future<List<TodoModel>> call(String noteId, DateTime date) {
    return _repository.getTodosByNoteIdAndDate(noteId, date);
  }
}