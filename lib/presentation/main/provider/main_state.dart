import '../../../domain/model/note_model.dart';
import '../../../domain/model/focus_record_model.dart';
import '../../../domain/model/todo_model.dart';

class MainState {
  final List<NoteModel> pinnedNotes;
  final List<NoteModel> todayNotes; // 오늘 선택된 노트들
  final List<FocusRecordModel> focusRecords;
  final Map<String, List<TodoModel>> todosByNote; // 노트별 할일 목록
  final int totalFocusTime;
  final DateTime selectedDate;
  final bool isTimeTableVisible;
  final bool isTodoVisible;
  final bool isLoading;

  MainState({
    this.pinnedNotes = const [],
    this.todayNotes = const [],
    this.focusRecords = const [],
    this.todosByNote = const {},
    this.totalFocusTime = 0,
    required this.selectedDate,
    this.isTimeTableVisible = false,
    this.isTodoVisible = false,
    this.isLoading = false,
  });

  MainState copyWith({
    List<NoteModel>? pinnedNotes,
    List<NoteModel>? todayNotes,
    List<FocusRecordModel>? focusRecords,
    Map<String, List<TodoModel>>? todosByNote,
    int? totalFocusTime,
    DateTime? selectedDate,
    bool? isTimeTableVisible,
    bool? isTodoVisible,
    bool? isLoading,
  }) {
    return MainState(
      pinnedNotes: pinnedNotes ?? this.pinnedNotes,
      todayNotes: todayNotes ?? this.todayNotes,
      focusRecords: focusRecords ?? this.focusRecords,
      todosByNote: todosByNote ?? this.todosByNote,
      totalFocusTime: totalFocusTime ?? this.totalFocusTime,
      selectedDate: selectedDate ?? this.selectedDate,
      isTimeTableVisible: isTimeTableVisible ?? this.isTimeTableVisible,
      isTodoVisible: isTodoVisible ?? this.isTodoVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory MainState.initial() => MainState(
        selectedDate: DateTime.now(),
      );
}