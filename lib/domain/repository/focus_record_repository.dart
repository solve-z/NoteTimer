import '../model/focus_record_model.dart';

abstract class FocusRecordRepository {
  /// 특정 날짜의 집중 기록 목록 조회
  Future<List<FocusRecordModel>> getRecordsByDate(DateTime date);

  /// 특정 날짜의 총 집중 시간 조회 (초 단위)
  Future<int> getTotalFocusTimeByDate(DateTime date);

  /// 특정 노트의 진행 중인 집중 기록 조회 (endTime이 null인 것)
  Future<FocusRecordModel?> getOngoingFocusRecord(String noteId);

  /// 집중 기록 생성
  Future<void> createFocusRecord(FocusRecordModel record);

  /// 집중 기록 업데이트
  Future<void> updateFocusRecord(FocusRecordModel record);

  /// 특정 노트의 오늘 총 집중 시간 조회 (초 단위)
  Future<int> getTodayTotalFocusTimeByNote(String noteId, DateTime date);
}