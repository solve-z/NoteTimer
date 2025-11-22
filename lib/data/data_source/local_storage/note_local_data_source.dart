import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/note_model.dart';

class NoteLocalDataSource {
  final Box<NoteModel> _noteBox;

  NoteLocalDataSource(this._noteBox);

  /// 고정된 노트 목록 조회
  Future<List<NoteModel>> getPinnedNotes() async {
    return _noteBox.values.where((note) => note.isPinned).toList();
  }

  /// 특정 날짜에 사용된 노트 목록 조회
  /// (추후 FocusRecord와 연동하여 해당 날짜에 기록이 있는 노트만 필터링)
  Future<List<NoteModel>> getNotesByDate(DateTime date) async {
    // TODO: FocusRecord 연동하여 실제 날짜별 필터링 구현
    return _noteBox.values.toList();
  }

  /// 노트 추가
  Future<void> addNote(NoteModel note) async {
    await _noteBox.put(note.id, note);
  }

  /// 노트 수정
  Future<void> updateNote(NoteModel note) async {
    await _noteBox.put(note.id, note);
  }

  /// 노트 삭제
  Future<void> deleteNote(String id) async {
    await _noteBox.delete(id);
  }

  /// 모든 노트 조회
  Future<List<NoteModel>> getAllNotes() async {
    return _noteBox.values.toList();
  }
}