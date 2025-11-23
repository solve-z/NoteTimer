import '../../model/memo_model.dart';
import '../../repository/memo_repository.dart';

class CreateMemoUseCase {
  final MemoRepository _repository;

  CreateMemoUseCase(this._repository);

  Future<void> call(MemoModel memo) {
    return _repository.createMemo(memo);
  }
}