import '../../model/memo_model.dart';
import '../../repository/memo_repository.dart';

class GetMemosByNoteIdUseCase {
  final MemoRepository _repository;

  GetMemosByNoteIdUseCase(this._repository);

  Future<List<MemoModel>> call(String noteId) {
    return _repository.getMemosByNoteId(noteId);
  }
}