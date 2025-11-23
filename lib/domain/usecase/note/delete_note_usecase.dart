import '../../repository/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  Future<void> call(String noteId) async {
    return await _repository.deleteNote(noteId);
  }
}