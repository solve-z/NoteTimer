import '../../repository/note_repository.dart';

class TogglePinNoteUseCase {
  final NoteRepository _repository;

  TogglePinNoteUseCase(this._repository);

  Future<void> call(String noteId) async {
    return await _repository.togglePinNote(noteId);
  }
}