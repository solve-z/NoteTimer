import '../../domain/model/focus_record_model.dart';
import '../../domain/repository/focus_record_repository.dart';
import '../data_source/local_storage/focus_record_local_data_source.dart';

class FocusRecordRepositoryImpl implements FocusRecordRepository {
  final FocusRecordLocalDataSource _localDataSource;

  FocusRecordRepositoryImpl(this._localDataSource);

  @override
  Future<List<FocusRecordModel>> getRecordsByDate(DateTime date) async {
    return await _localDataSource.getRecordsByDate(date);
  }

  @override
  Future<int> getTotalFocusTimeByDate(DateTime date) async {
    return await _localDataSource.getTotalFocusTimeByDate(date);
  }
}