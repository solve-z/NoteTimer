import '../model/focus_record_model.dart';

abstract class FocusRecordRepository {
  /// 특정 날짜의 집중 기록 목록 조회
  Future<List<FocusRecordModel>> getRecordsByDate(DateTime date);

  /// 특정 날짜의 총 집중 시간 조회 (초 단위)
  Future<int> getTotalFocusTimeByDate(DateTime date);
}