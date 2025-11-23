import '../../domain/model/note_model.dart';
import '../../domain/repository/note_repository.dart';
import '../data_source/local_storage/note_local_data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource _localDataSource;

  NoteRepositoryImpl(this._localDataSource);

  @override
  Future<List<NoteModel>> getPinnedNotes() async {
    return await _localDataSource.getPinnedNotes();
  }

  @override
  Future<List<NoteModel>> getNotesByDate(DateTime date) async {
    return await _localDataSource.getNotesByDate(date);
  }

  @override
  Future<List<NoteModel>> getAllActiveNotes() async {
    return await _localDataSource.getAllActiveNotes();
  }

  @override
  Future<List<NoteModel>> getAllArchivedNotes() async {
    return await _localDataSource.getAllArchivedNotes();
  }

  @override
  Future<void> createNote(NoteModel note) async {
    return await _localDataSource.addNote(note);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    return await _localDataSource.updateNote(note);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    return await _localDataSource.deleteNote(noteId);
  }

  @override
  Future<void> archiveNote(String noteId) async {
    return await _localDataSource.archiveNote(noteId);
  }

  @override
  Future<void> unarchiveNote(String noteId) async {
    return await _localDataSource.unarchiveNote(noteId);
  }

  @override
  Future<void> togglePinNote(String noteId) async {
    return await _localDataSource.togglePinNote(noteId);
  }

  @override
  Future<void> toggleSelectForToday(String noteId) async {
    return await _localDataSource.toggleSelectForToday(noteId);
  }

  @override
  Future<void> updateNoteOrder(List<String> noteIds) async {
    return await _localDataSource.updateNoteOrder(noteIds);
  }

  @override
  Future<void> resetTodaySelection() async {
    return await _localDataSource.resetTodaySelection();
  }

  @override
  Future<NoteModel?> getNoteById(String noteId) async {
    final notes = await _localDataSource.getAllNotes();
    try {
      return notes.firstWhere((note) => note.id == noteId);
    } catch (e) {
      return null;
    }
  }
}