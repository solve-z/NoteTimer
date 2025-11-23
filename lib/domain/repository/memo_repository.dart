import '../model/memo_model.dart';

abstract class MemoRepository {
  /// 특정 노트의 메모 목록 조회
  Future<List<MemoModel>> getMemosByNoteId(String noteId);

  /// 특정 날짜의 메모 목록 조회
  Future<List<MemoModel>> getMemosByDate(DateTime date);

  /// 특정 노트의 특정 날짜 메모 목록 조회
  Future<List<MemoModel>> getMemosByNoteIdAndDate(String noteId, DateTime date);

  /// 메모 추가
  Future<void> createMemo(MemoModel memo);

  /// 메모 수정
  Future<void> updateMemo(MemoModel memo);

  /// 메모 삭제
  Future<void> deleteMemo(String memoId);

  /// 메모 날짜 이동
  Future<void> moveMemoToDate(String memoId, DateTime newDate);

  /// 메모 순서 변경
  Future<void> updateMemoOrder(List<String> memoIds);

  /// 메모 상세 조회
  Future<MemoModel?> getMemoById(String memoId);
}