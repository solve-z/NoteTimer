import '../../repository/note_repository.dart';

class ResetTodaySelectionUseCase {
  final NoteRepository _repository;

  ResetTodaySelectionUseCase(this._repository);

  Future<void> call() async {
    return await _repository.resetTodaySelection();
  }
}