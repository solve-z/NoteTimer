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

  @override
  Future<FocusRecordModel?> getOngoingFocusRecord(String noteId) async {
    return await _localDataSource.getOngoingFocusRecord(noteId);
  }

  @override
  Future<void> createFocusRecord(FocusRecordModel record) async {
    return await _localDataSource.addRecord(record);
  }

  @override
  Future<void> updateFocusRecord(FocusRecordModel record) async {
    return await _localDataSource.updateRecord(record);
  }

  @override
  Future<int> getTodayTotalFocusTimeByNote(String noteId, DateTime date) async {
    return await _localDataSource.getTodayTotalFocusTimeByNote(noteId, date);
  }
}