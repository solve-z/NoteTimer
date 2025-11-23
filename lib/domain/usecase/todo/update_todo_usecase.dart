import '../../model/todo_model.dart';
import '../../repository/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository _repository;

  UpdateTodoUseCase(this._repository);

  Future<void> call(TodoModel todo) {
    return _repository.updateTodo(todo);
  }
}