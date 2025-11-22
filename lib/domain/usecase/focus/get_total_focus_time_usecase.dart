import '../../repository/focus_record_repository.dart';

class GetTotalFocusTimeUseCase {
  final FocusRecordRepository _repository;

  GetTotalFocusTimeUseCase(this._repository);

  Future<int> call(DateTime date) async {
    return await _repository.getTotalFocusTimeByDate(date);
  }
}