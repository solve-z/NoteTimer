import '../../model/note_model.dart';
import '../../repository/note_repository.dart';

class GetAllActiveNotesUseCase {
  final NoteRepository _repository;

  GetAllActiveNotesUseCase(this._repository);

  Future<List<NoteModel>> call() async {
    return await _repository.getAllActiveNotes();
  }
}