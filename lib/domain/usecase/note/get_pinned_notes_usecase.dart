import '../../model/note_model.dart';
import '../../repository/note_repository.dart';

class GetPinnedNotesUseCase {
  final NoteRepository _repository;

  GetPinnedNotesUseCase(this._repository);

  Future<List<NoteModel>> call() async {
    return await _repository.getPinnedNotes();
  }
}