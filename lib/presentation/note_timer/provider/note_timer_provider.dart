import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/model/focus_record_model.dart';
import '../../../domain/usecase/note/get_note_by_id_usecase.dart';
import '../../../domain/usecase/focus_record/get_ongoing_focus_record_usecase.dart';
import '../../../domain/usecase/focus_record/create_focus_record_usecase.dart';
import '../../../domain/usecase/focus_record/update_focus_record_usecase.dart';
import '../../../domain/usecase/focus_record/get_today_total_focus_time_by_note_usecase.dart';
import 'note_timer_state.dart';

class NoteTimerNotifier extends StateNotifier<NoteTimerState> {
  final GetNoteByIdUseCase _getNoteByIdUseCase;
  final GetOngoingFocusRecordUseCase _getOngoingFocusRecordUseCase;
  final CreateFocusRecordUseCase _createFocusRecordUseCase;
  final UpdateFocusRecordUseCase _updateFocusRecordUseCase;
  final GetTodayTotalFocusTimeByNoteUseCase _getTodayTotalFocusTimeByNoteUseCase;

  Timer? _timer;
  DateTime? _sessionStartTime;

  NoteTimerNotifier({
    required GetNoteByIdUseCase getNoteByIdUseCase,
    required GetOngoingFocusRecordUseCase getOngoingFocusRecordUseCase,
    required CreateFocusRecordUseCase createFocusRecordUseCase,
    required UpdateFocusRecordUseCase updateFocusRecordUseCase,
    required GetTodayTotalFocusTimeByNoteUseCase getTodayTotalFocusTimeByNoteUseCase,
  })  : _getNoteByIdUseCase = getNoteByIdUseCase,
        _getOngoingFocusRecordUseCase = getOngoingFocusRecordUseCase,
        _createFocusRecordUseCase = createFocusRecordUseCase,
        _updateFocusRecordUseCase = updateFocusRecordUseCase,
        _getTodayTotalFocusTimeByNoteUseCase = getTodayTotalFocusTimeByNoteUseCase,
        super(NoteTimerState());

  /// 노트 정보 로드 및 진행 중인 세션 확인
  Future<void> loadNoteData(String noteId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // 노트 정보 조회
      final note = await _getNoteByIdUseCase(noteId);

      // 오늘 총 집중 시간 조회
      final totalFocusTime = await _getTodayTotalFocusTimeByNoteUseCase(noteId, DateTime.now());

      // 진행 중인 집중 기록 확인
      final ongoingRecord = await _getOngoingFocusRecordUseCase(noteId);

      state = state.copyWith(
        note: note,
        todayTotalFocusTime: totalFocusTime,
        isLoading: false,
      );

      // 진행 중인 기록이 있으면 타이머 재개
      if (ongoingRecord != null) {
        final elapsed = DateTime.now().difference(ongoingRecord.startTime).inSeconds;
        state = state.copyWith(
          currentTime: elapsed,
          isRunning: true,
          focusRecordId: ongoingRecord.id,
        );
        _startTimer();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '노트 정보를 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 집중 시작
  Future<void> startFocus() async {
    if (state.note == null) return;

    try {
      _sessionStartTime = DateTime.now();
      final recordId = const Uuid().v4();

      final record = FocusRecordModel(
        id: recordId,
        noteId: state.note!.id,
        startTime: _sessionStartTime!,
        endTime: null,
        duration: 0,
        userId: 'current_user_id', // TODO: 실제 유저 ID 가져오기
        createdAt: DateTime.now(),
      );

      await _createFocusRecordUseCase(record);

      state = state.copyWith(
        isRunning: true,
        focusRecordId: recordId,
        currentTime: 0,
        isFocusMode: true,
      );

      _startTimer();
    } catch (e) {
      state = state.copyWith(errorMessage: '집중 시작에 실패했습니다: $e');
    }
  }

  /// 집중 종료
  Future<void> endFocus() async {
    if (state.focusRecordId == null || state.note == null) return;

    try {
      _stopTimer();

      final endTime = DateTime.now();
      final duration = state.currentTime;

      // 기존 기록 가져와서 업데이트
      final ongoingRecord = await _getOngoingFocusRecordUseCase(state.note!.id);
      if (ongoingRecord != null) {
        final updatedRecord = ongoingRecord.copyWith(
          endTime: endTime,
          duration: duration,
        );
        await _updateFocusRecordUseCase(updatedRecord);
      }

      // 오늘 총 시간 다시 계산
      final totalFocusTime = await _getTodayTotalFocusTimeByNoteUseCase(state.note!.id, DateTime.now());

      state = state.copyWith(
        isRunning: false,
        focusRecordId: null,
        currentTime: 0,
        todayTotalFocusTime: totalFocusTime,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: '집중 종료에 실패했습니다: $e');
    }
  }

  /// 휴식 시작
  void startBreak() {
    if (!state.isRunning) return;

    _stopTimer();
    state = state.copyWith(
      isFocusMode: false,
      isRunning: true,
    );
    _startBreakTimer();
  }

  /// 휴식 종료
  void endBreak() {
    if (state.isFocusMode) return;

    _stopTimer();
    state = state.copyWith(
      isFocusMode: true,
      isRunning: true,
      breakTime: 0,
    );
    _startTimer();
  }

  /// 타이머 시작 (집중 모드)
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(currentTime: state.currentTime + 1);
    });
  }

  /// 휴식 타이머 시작
  void _startBreakTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(breakTime: state.breakTime + 1);
    });
  }

  /// 타이머 정지
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

final noteTimerProvider = StateNotifierProvider.family<NoteTimerNotifier, NoteTimerState, String>((ref, noteId) {
  final notifier = NoteTimerNotifier(
    getNoteByIdUseCase: getIt<GetNoteByIdUseCase>(),
    getOngoingFocusRecordUseCase: getIt<GetOngoingFocusRecordUseCase>(),
    createFocusRecordUseCase: getIt<CreateFocusRecordUseCase>(),
    updateFocusRecordUseCase: getIt<UpdateFocusRecordUseCase>(),
    getTodayTotalFocusTimeByNoteUseCase: getIt<GetTodayTotalFocusTimeByNoteUseCase>(),
  );

  // 초기 로드
  notifier.loadNoteData(noteId);

  return notifier;
});