import '../../repository/todo_repository.dart';

class ToggleTodoCompleteUseCase {
  final TodoRepository _repository;

  ToggleTodoCompleteUseCase(this._repository);

  Future<void> call(String todoId) {
    return _repository.toggleTodoCompletion(todoId);
  }
}