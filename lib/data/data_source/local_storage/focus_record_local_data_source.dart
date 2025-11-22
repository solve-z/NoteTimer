import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/focus_record_model.dart';

class FocusRecordLocalDataSource {
  final Box<FocusRecordModel> _focusRecordBox;

  FocusRecordLocalDataSource(this._focusRecordBox);

  /// 특정 날짜의 집중 기록 목록 조회
  Future<List<FocusRecordModel>> getRecordsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _focusRecordBox.values.where((record) {
      return record.startTime.isAfter(startOfDay) &&
          record.startTime.isBefore(endOfDay);
    }).toList();
  }

  /// 특정 날짜의 총 집중 시간 조회 (초 단위)
  Future<int> getTotalFocusTimeByDate(DateTime date) async {
    final records = await getRecordsByDate(date);
    return records.fold<int>(0, (sum, record) => sum + record.duration);
  }

  /// 집중 기록 추가
  Future<void> addRecord(FocusRecordModel record) async {
    await _focusRecordBox.put(record.id, record);
  }

  /// 집중 기록 수정
  Future<void> updateRecord(FocusRecordModel record) async {
    await _focusRecordBox.put(record.id, record);
  }

  /// 집중 기록 삭제
  Future<void> deleteRecord(String id) async {
    await _focusRecordBox.delete(id);
  }

  /// 모든 집중 기록 조회
  Future<List<FocusRecordModel>> getAllRecords() async {
    return _focusRecordBox.values.toList();
  }
}