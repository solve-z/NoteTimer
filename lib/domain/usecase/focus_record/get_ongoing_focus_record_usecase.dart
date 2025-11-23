import '../../model/focus_record_model.dart';
import '../../repository/focus_record_repository.dart';

class GetOngoingFocusRecordUseCase {
  final FocusRecordRepository _repository;

  GetOngoingFocusRecordUseCase(this._repository);

  Future<FocusRecordModel?> call(String noteId) async {
    return await _repository.getOngoingFocusRecord(noteId);
  }
}