import '../../repository/focus_record_repository.dart';

class GetTodayTotalFocusTimeByNoteUseCase {
  final FocusRecordRepository _repository;

  GetTodayTotalFocusTimeByNoteUseCase(this._repository);

  Future<int> call(String noteId, DateTime date) async {
    return await _repository.getTodayTotalFocusTimeByNote(noteId, date);
  }
}