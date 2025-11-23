import '../../model/focus_record_model.dart';
import '../../repository/focus_record_repository.dart';

class CreateFocusRecordUseCase {
  final FocusRecordRepository _repository;

  CreateFocusRecordUseCase(this._repository);

  Future<void> call(FocusRecordModel record) async {
    return await _repository.createFocusRecord(record);
  }
}