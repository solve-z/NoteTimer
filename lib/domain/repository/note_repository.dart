import '../model/note_model.dart';

abstract class NoteRepository {
  /// 고정된 노트 목록 조회
  Future<List<NoteModel>> getPinnedNotes();

  /// 특정 날짜에 사용된 노트 목록 조회
  Future<List<NoteModel>> getNotesByDate(DateTime date);
}
