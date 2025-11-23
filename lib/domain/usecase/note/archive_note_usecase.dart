import '../../repository/note_repository.dart';

class ArchiveNoteUseCase {
  final NoteRepository _repository;

  ArchiveNoteUseCase(this._repository);

  Future<void> call(String noteId) async {
    return await _repository.archiveNote(noteId);
  }
}