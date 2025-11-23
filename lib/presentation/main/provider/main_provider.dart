import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/usecase/note/get_pinned_notes_usecase.dart';
import '../../../domain/usecase/note/get_notes_by_date_usecase.dart';
import '../../../domain/usecase/focus/get_records_by_date_usecase.dart';
import '../../../domain/usecase/focus/get_total_focus_time_usecase.dart';
import '../../../domain/usecase/todo/get_todos_by_note_and_date_usecase.dart';
import '../../../domain/usecase/todo/toggle_todo_complete_usecase.dart';
import '../../../domain/model/todo_model.dart';
import 'main_state.dart';

/// Main 페이지 상태
final mainStateProvider = StateProvider<MainState>((ref) => MainState.initial());

/// 날짜별 데이터 로드
final loadDataByDateProvider = Provider((ref) {
  return (DateTime date) async {
    final state = ref.read(mainStateProvider.notifier);

    // 로딩 시작
    state.state = state.state.copyWith(isLoading: true, selectedDate: date);

    try {
      // UseCase 호출
      final getPinnedNotesUseCase = getIt<GetPinnedNotesUseCase>();
      final getNotesByDateUseCase = getIt<GetNotesByDateUseCase>();
      final getRecordsByDateUseCase = getIt<GetRecordsByDateUseCase>();
      final getTotalFocusTimeUseCase = getIt<GetTotalFocusTimeUseCase>();
      final getTodosByNoteAndDateUseCase = getIt<GetTodosByNoteAndDateUseCase>();

      final pinnedNotes = await getPinnedNotesUseCase();
      final todayNotes = await getNotesByDateUseCase(date);
      final focusRecords = await getRecordsByDateUseCase(date);
      final totalFocusTime = await getTotalFocusTimeUseCase(date);

      // 각 노트별 할일 로드
      final Map<String, List<TodoModel>> todosByNote = {};
      for (final note in todayNotes) {
        final todos = await getTodosByNoteAndDateUseCase(note.id, date);
        todosByNote[note.id] = todos;
      }

      // 상태 업데이트
      state.state = state.state.copyWith(
        pinnedNotes: pinnedNotes,
        todayNotes: todayNotes,
        focusRecords: focusRecords,
        todosByNote: todosByNote,
        totalFocusTime: totalFocusTime,
        isLoading: false,
      );
    } catch (e) {
      // 에러 처리
      state.state = state.state.copyWith(isLoading: false);
    }
  };
});

/// 타임테이블 표시/숨김 토글
final toggleTimeTableProvider = Provider((ref) {
  return () {
    final state = ref.read(mainStateProvider.notifier);
    state.state = state.state.copyWith(
      isTimeTableVisible: !state.state.isTimeTableVisible,
    );
  };
});

/// 할일 표시/숨김 토글
final toggleTodoProvider = Provider((ref) {
  return () {
    final state = ref.read(mainStateProvider.notifier);
    state.state = state.state.copyWith(
      isTodoVisible: !state.state.isTodoVisible,
    );
  };
});

/// 선택된 날짜 변경
final changeSelectedDateProvider = Provider((ref) {
  return (DateTime date) {
    ref.read(loadDataByDateProvider)(date);
  };
});

/// 할일 완료 토글
final toggleTodoCompleteProvider = Provider((ref) {
  return (String todoId) async {
    try {
      final toggleTodoCompleteUseCase = getIt<ToggleTodoCompleteUseCase>();
      await toggleTodoCompleteUseCase(todoId);

      // 현재 날짜 데이터 새로고침
      final currentDate = ref.read(mainStateProvider).selectedDate;
      await ref.read(loadDataByDateProvider)(currentDate);
    } catch (e) {
      // 에러 처리
      print('할일 완료 토글 실패: $e');
    }
  };
});