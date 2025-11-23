import '../../repository/note_repository.dart';

class UnarchiveNoteUseCase {
  final NoteRepository _repository;

  UnarchiveNoteUseCase(this._repository);

  Future<void> call(String noteId) async {
    return await _repository.unarchiveNote(noteId);
  }
}