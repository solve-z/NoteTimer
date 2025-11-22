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
}