import '../../model/todo_model.dart';
import '../../repository/todo_repository.dart';

class GetTodosByNoteIdUseCase {
  final TodoRepository _repository;

  GetTodosByNoteIdUseCase(this._repository);

  Future<List<TodoModel>> call(String noteId) {
    return _repository.getTodosByNoteId(noteId);
  }
}