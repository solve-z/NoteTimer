import '../../model/todo_model.dart';
import '../../repository/todo_repository.dart';

class CreateTodoUseCase {
  final TodoRepository _repository;

  CreateTodoUseCase(this._repository);

  Future<void> call(TodoModel todo) {
    return _repository.createTodo(todo);
  }
}