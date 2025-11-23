import '../../repository/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;

  DeleteTodoUseCase(this._repository);

  Future<void> call(String todoId) {
    return _repository.deleteTodo(todoId);
  }
}