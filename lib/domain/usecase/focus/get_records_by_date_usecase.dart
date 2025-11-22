import '../../model/focus_record_model.dart';
import '../../repository/focus_record_repository.dart';

class GetRecordsByDateUseCase {
  final FocusRecordRepository _repository;

  GetRecordsByDateUseCase(this._repository);

  Future<List<FocusRecordModel>> call(DateTime date) async {
    return await _repository.getRecordsByDate(date);
  }
}