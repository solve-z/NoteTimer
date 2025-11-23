import '../../model/note_model.dart';
import '../../repository/note_repository.dart';

class GetAllArchivedNotesUseCase {
  final NoteRepository _repository;

  GetAllArchivedNotesUseCase(this._repository);

  Future<List<NoteModel>> call() async {
    return await _repository.getAllArchivedNotes();
  }
}