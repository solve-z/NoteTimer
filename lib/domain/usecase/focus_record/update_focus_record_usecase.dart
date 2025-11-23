import '../../model/focus_record_model.dart';
import '../../repository/focus_record_repository.dart';

class UpdateFocusRecordUseCase {
  final FocusRecordRepository _repository;

  UpdateFocusRecordUseCase(this._repository);

  Future<void> call(FocusRecordModel record) async {
    return await _repository.updateFocusRecord(record);
  }
}