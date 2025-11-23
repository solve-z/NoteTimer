import '../../../domain/model/note_model.dart';

class NoteTimerState {
  final NoteModel? note;
  final int currentTime; // 초 단위 - 현재 집중 타이머 시간
  final int todayTotalFocusTime; // 초 단위 - 오늘 총 집중 시간
  final int breakTime; // 초 단위 - 휴식 시간
  final bool isFocusMode; // true: 집중 모드, false: 휴식 모드
  final bool isRunning; // 타이머 실행 중 여부
  final String? focusRecordId; // 진행 중인 집중 기록 ID
  final bool isLoading;
  final String? errorMessage;

  NoteTimerState({
    this.note,
    this.currentTime = 0,
    this.todayTotalFocusTime = 0,
    this.breakTime = 0,
    this.isFocusMode = true,
    this.isRunning = false,
    this.focusRecordId,
    this.isLoading = false,
    this.errorMessage,
  });

  NoteTimerState copyWith({
    NoteModel? note,
    int? currentTime,
    int? todayTotalFocusTime,
    int? breakTime,
    bool? isFocusMode,
    bool? isRunning,
    String? focusRecordId,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NoteTimerState(
      note: note ?? this.note,
      currentTime: currentTime ?? this.currentTime,
      todayTotalFocusTime: todayTotalFocusTime ?? this.todayTotalFocusTime,
      breakTime: breakTime ?? this.breakTime,
      isFocusMode: isFocusMode ?? this.isFocusMode,
      isRunning: isRunning ?? this.isRunning,
      focusRecordId: focusRecordId ?? this.focusRecordId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}