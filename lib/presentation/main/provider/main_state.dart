import '../../../domain/model/note_model.dart';
import '../../../domain/model/focus_record_model.dart';

class MainState {
  final List<NoteModel> pinnedNotes;
  final List<FocusRecordModel> focusRecords;
  final int totalFocusTime;
  final DateTime selectedDate;
  final bool isTimeTableVisible;
  final bool isTodoVisible;
  final bool isLoading;

  MainState({
    this.pinnedNotes = const [],
    this.focusRecords = const [],
    this.totalFocusTime = 0,
    required this.selectedDate,
    this.isTimeTableVisible = false,
    this.isTodoVisible = false,
    this.isLoading = false,
  });

  MainState copyWith({
    List<NoteModel>? pinnedNotes,
    List<FocusRecordModel>? focusRecords,
    int? totalFocusTime,
    DateTime? selectedDate,
    bool? isTimeTableVisible,
    bool? isTodoVisible,
    bool? isLoading,
  }) {
    return MainState(
      pinnedNotes: pinnedNotes ?? this.pinnedNotes,
      focusRecords: focusRecords ?? this.focusRecords,
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