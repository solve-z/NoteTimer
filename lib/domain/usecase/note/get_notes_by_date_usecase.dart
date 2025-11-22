import '../../model/note_model.dart';
import '../../repository/note_repository.dart';

class GetNotesByDateUseCase {
  final NoteRepository _repository;

  GetNotesByDateUseCase(this._repository);

  Future<List<NoteModel>> call(DateTime date) async {
    return await _repository.getNotesByDate(date);
  }
}