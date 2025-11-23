import '../../repository/note_repository.dart';

class UpdateNoteOrderUseCase {
  final NoteRepository _repository;

  UpdateNoteOrderUseCase(this._repository);

  Future<void> call(List<String> noteIds) async {
    return await _repository.updateNoteOrder(noteIds);
  }
}