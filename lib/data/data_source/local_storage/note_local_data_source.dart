import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/note_model.dart';

class NoteLocalDataSource {
  final Box<NoteModel> _noteBox;

  NoteLocalDataSource(this._noteBox);

  /// 고정된 노트 목록 조회
  Future<List<NoteModel>> getPinnedNotes() async {
    return _noteBox.values.where((note) => note.isPinned).toList();
  }

  /// 특정 날짜에 사용된 노트 목록 조회 (고정된 노트 + 오늘 선택된 노트)
  Future<List<NoteModel>> getNotesByDate(DateTime date) async {
    return _noteBox.values
        .where((note) => (note.isPinned || note.isSelectedForToday) && !note.isArchived)
        .toList()
      ..sort((a, b) {
        // 고정된 노트가 먼저 오도록
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        // 같은 고정 상태면 sortOrder로 정렬
        return a.sortOrder.compareTo(b.sortOrder);
      });
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

  /// 사용중 노트 목록 조회 (isArchived = false)
  Future<List<NoteModel>> getAllActiveNotes() async {
    return _noteBox.values
        .where((note) => !note.isArchived)
        .toList()
      ..sort((a, b) {
        // 고정된 노트가 먼저 오도록
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        // 같은 고정 상태면 sortOrder로 정렬
        return a.sortOrder.compareTo(b.sortOrder);
      });
  }

  /// 보관함 노트 목록 조회 (isArchived = true)
  Future<List<NoteModel>> getAllArchivedNotes() async {
    return _noteBox.values
        .where((note) => note.isArchived)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// 노트 보관
  Future<void> archiveNote(String noteId) async {
    final note = _noteBox.get(noteId);
    if (note != null) {
      final updatedNote = note.copyWith(isArchived: true);
      await _noteBox.put(noteId, updatedNote);
    }
  }

  /// 보관 해제
  Future<void> unarchiveNote(String noteId) async {
    final note = _noteBox.get(noteId);
    if (note != null) {
      final updatedNote = note.copyWith(isArchived: false);
      await _noteBox.put(noteId, updatedNote);
    }
  }

  /// 고정/고정 해제 토글
  Future<void> togglePinNote(String noteId) async {
    final note = _noteBox.get(noteId);
    if (note != null) {
      final updatedNote = note.copyWith(isPinned: !note.isPinned);
      await _noteBox.put(noteId, updatedNote);
    }
  }

  /// 오늘 사용 체크 토글
  Future<void> toggleSelectForToday(String noteId) async {
    final note = _noteBox.get(noteId);
    if (note != null) {
      final updatedNote = note.copyWith(isSelectedForToday: !note.isSelectedForToday);
      await _noteBox.put(noteId, updatedNote);
    }
  }

  /// 드래그 앤 드롭으로 순서 변경
  Future<void> updateNoteOrder(List<String> noteIds) async {
    for (int i = 0; i < noteIds.length; i++) {
      final note = _noteBox.get(noteIds[i]);
      if (note != null) {
        final updatedNote = note.copyWith(sortOrder: i);
        await _noteBox.put(noteIds[i], updatedNote);
      }
    }
  }

  /// 오늘 사용 체크 초기화 (오전 6시 이후)
  Future<void> resetTodaySelection() async {
    for (final note in _noteBox.values) {
      if (note.isSelectedForToday) {
        final updatedNote = note.copyWith(isSelectedForToday: false);
        await _noteBox.put(note.id, updatedNote);
      }
    }
  }
}