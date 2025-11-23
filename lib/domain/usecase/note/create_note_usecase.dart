import '../../model/note_model.dart';
import '../../repository/note_repository.dart';

class CreateNoteUseCase {
  final NoteRepository _repository;

  CreateNoteUseCase(this._repository);

  Future<void> call(NoteModel note) async {
    return await _repository.createNote(note);
  }
}