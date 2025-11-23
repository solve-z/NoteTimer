import '../../domain/model/memo_model.dart';
import '../../domain/repository/memo_repository.dart';
import '../data_source/local_storage/memo_local_data_source.dart';

class MemoRepositoryImpl implements MemoRepository {
  final MemoLocalDataSource _localDataSource;

  MemoRepositoryImpl(this._localDataSource);

  @override
  Future<List<MemoModel>> getMemosByNoteId(String noteId) async {
    return await _localDataSource.getMemosByNoteId(noteId);
  }

  @override
  Future<List<MemoModel>> getMemosByDate(DateTime date) async {
    return await _localDataSource.getMemosByDate(date);
  }

  @override
  Future<List<MemoModel>> getMemosByNoteIdAndDate(String noteId, DateTime date) async {
    return await _localDataSource.getMemosByNoteIdAndDate(noteId, date);
  }

  @override
  Future<void> createMemo(MemoModel memo) async {
    return await _localDataSource.createMemo(memo);
  }

  @override
  Future<void> updateMemo(MemoModel memo) async {
    return await _localDataSource.updateMemo(memo);
  }

  @override
  Future<void> deleteMemo(String memoId) async {
    return await _localDataSource.deleteMemo(memoId);
  }

  @override
  Future<void> moveMemoToDate(String memoId, DateTime newDate) async {
    return await _localDataSource.moveMemoToDate(memoId, newDate);
  }

  @override
  Future<void> updateMemoOrder(List<String> memoIds) async {
    return await _localDataSource.updateMemoOrder(memoIds);
  }

  @override
  Future<MemoModel?> getMemoById(String memoId) async {
    return await _localDataSource.getMemoById(memoId);
  }
}