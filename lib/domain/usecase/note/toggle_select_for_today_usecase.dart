import '../../repository/note_repository.dart';

class ToggleSelectForTodayUseCase {
  final NoteRepository _repository;

  ToggleSelectForTodayUseCase(this._repository);

  Future<void> call(String noteId) async {
    return await _repository.toggleSelectForToday(noteId);
  }
}