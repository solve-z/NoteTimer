import '../../repository/todo_repository.dart';

class MoveTodoToDateUseCase {
  final TodoRepository _repository;

  MoveTodoToDateUseCase(this._repository);

  Future<void> call(String todoId, DateTime newDate) {
    return _repository.moveTodoToDate(todoId, newDate);
  }
}