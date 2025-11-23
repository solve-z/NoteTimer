import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/memo_model.dart';

class MemoLocalDataSource {
  final Box<MemoModel> _memoBox;

  MemoLocalDataSource(this._memoBox);

  /// 특정 노트의 메모 목록 조회
  Future<List<MemoModel>> getMemosByNoteId(String noteId) async {
    return _memoBox.values
        .where((memo) => memo.noteId == noteId)
        .toList()
      ..sort((a, b) {
        // 날짜 내림차순 (최신순)
        final dateCompare = b.assignedDate.compareTo(a.assignedDate);
        if (dateCompare != 0) return dateCompare;
        // 같은 날짜면 sortOrder로 정렬
        return a.sortOrder.compareTo(b.sortOrder);
      });
  }

  /// 특정 날짜의 메모 목록 조회
  Future<List<MemoModel>> getMemosByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _memoBox.values
        .where((memo) =>
            memo.assignedDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            memo.assignedDate.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// 특정 노트의 특정 날짜 메모 목록 조회
  Future<List<MemoModel>> getMemosByNoteIdAndDate(String noteId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _memoBox.values
        .where((memo) =>
            memo.noteId == noteId &&
            memo.assignedDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            memo.assignedDate.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// 메모 추가
  Future<void> createMemo(MemoModel memo) async {
    await _memoBox.put(memo.id, memo);
  }

  /// 메모 수정
  Future<void> updateMemo(MemoModel memo) async {
    await _memoBox.put(memo.id, memo);
  }

  /// 메모 삭제
  Future<void> deleteMemo(String memoId) async {
    await _memoBox.delete(memoId);
  }

  /// 메모 날짜 이동
  Future<void> moveMemoToDate(String memoId, DateTime newDate) async {
    final memo = _memoBox.get(memoId);
    if (memo != null) {
      final updatedMemo = memo.copyWith(
        assignedDate: newDate,
        updatedAt: DateTime.now(),
      );
      await _memoBox.put(memoId, updatedMemo);
    }
  }

  /// 메모 순서 변경
  Future<void> updateMemoOrder(List<String> memoIds) async {
    for (int i = 0; i < memoIds.length; i++) {
      final memo = _memoBox.get(memoIds[i]);
      if (memo != null) {
        final updatedMemo = memo.copyWith(sortOrder: i);
        await _memoBox.put(memoIds[i], updatedMemo);
      }
    }
  }

  /// 메모 상세 조회
  Future<MemoModel?> getMemoById(String memoId) async {
    return _memoBox.get(memoId);
  }

  /// 모든 메모 조회
  Future<List<MemoModel>> getAllMemos() async {
    return _memoBox.values.toList();
  }
}