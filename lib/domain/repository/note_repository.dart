import '../model/note_model.dart';

abstract class NoteRepository {
  /// 고정된 노트 목록 조회
  Future<List<NoteModel>> getPinnedNotes();

  /// 특정 날짜에 사용된 노트 목록 조회
  Future<List<NoteModel>> getNotesByDate(DateTime date);

  /// 사용중 노트 목록 조회 (isArchived = false)
  Future<List<NoteModel>> getAllActiveNotes();

  /// 보관함 노트 목록 조회 (isArchived = true)
  Future<List<NoteModel>> getAllArchivedNotes();

  /// 특정 노트 조회
  Future<NoteModel?> getNoteById(String noteId);

  /// 노트 추가
  Future<void> createNote(NoteModel note);

  /// 노트 수정
  Future<void> updateNote(NoteModel note);

  /// 노트 삭제
  Future<void> deleteNote(String noteId);

  /// 노트 보관
  Future<void> archiveNote(String noteId);

  /// 보관 해제
  Future<void> unarchiveNote(String noteId);

  /// 고정/고정 해제 토글
  Future<void> togglePinNote(String noteId);

  /// 오늘 사용 체크 토글
  Future<void> toggleSelectForToday(String noteId);

  /// 드래그 앤 드롭으로 순서 변경
  Future<void> updateNoteOrder(List<String> noteIds);

  /// 오늘 사용 체크 초기화 (오전 6시 이후)
  Future<void> resetTodaySelection();
}
