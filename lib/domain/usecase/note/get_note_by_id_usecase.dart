import '../../model/note_model.dart';
import '../../repository/note_repository.dart';

class GetNoteByIdUseCase {
  final NoteRepository _repository;

  GetNoteByIdUseCase(this._repository);

  Future<NoteModel?> call(String noteId) {
    return _repository.getNoteById(noteId);
  }
}