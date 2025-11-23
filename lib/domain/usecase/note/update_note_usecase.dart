import '../../model/note_model.dart';
import '../../repository/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository _repository;

  UpdateNoteUseCase(this._repository);

  Future<void> call(NoteModel note) async {
    return await _repository.updateNote(note);
  }
}