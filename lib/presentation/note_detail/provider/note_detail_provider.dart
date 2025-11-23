import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/usecase/note/get_note_by_id_usecase.dart';
import '../../../domain/usecase/todo/get_todos_by_note_id_usecase.dart';
import '../../../domain/usecase/todo/toggle_todo_complete_usecase.dart';
import '../../../domain/usecase/todo/move_todo_to_date_usecase.dart';
import '../../../domain/usecase/todo/delete_todo_usecase.dart';
import '../../../domain/usecase/todo/update_todo_usecase.dart';
import '../../../domain/usecase/memo/get_memos_by_note_id_usecase.dart';
import 'note_detail_state.dart';

class NoteDetailNotifier extends StateNotifier<NoteDetailState> {
  final GetNoteByIdUseCase _getNoteByIdUseCase;
  final GetTodosByNoteIdUseCase _getTodosByNoteIdUseCase;
  final ToggleTodoCompleteUseCase _toggleTodoCompleteUseCase;
  final MoveTodoToDateUseCase _moveTodoToDateUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final GetMemosByNoteIdUseCase _getMemosByNoteIdUseCase;

  NoteDetailNotifier({
    required GetNoteByIdUseCase getNoteByIdUseCase,
    required GetTodosByNoteIdUseCase getTodosByNoteIdUseCase,
    required ToggleTodoCompleteUseCase toggleTodoCompleteUseCase,
    required MoveTodoToDateUseCase moveTodoToDateUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required GetMemosByNoteIdUseCase getMemosByNoteIdUseCase,
  })  : _getNoteByIdUseCase = getNoteByIdUseCase,
        _getTodosByNoteIdUseCase = getTodosByNoteIdUseCase,
        _toggleTodoCompleteUseCase = toggleTodoCompleteUseCase,
        _moveTodoToDateUseCase = moveTodoToDateUseCase,
        _deleteTodoUseCase = deleteTodoUseCase,
        _updateTodoUseCase = updateTodoUseCase,
        _getMemosByNoteIdUseCase = getMemosByNoteIdUseCase,
        super(NoteDetailState());

  /// 노트 상세 정보 및 할일/메모 로드
  Future<void> loadNoteDetail(String noteId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // 노트 정보 조회
      final note = await _getNoteByIdUseCase(noteId);

      // 할일 목록 조회
      final todos = await _getTodosByNoteIdUseCase(noteId);

      // 메모 목록 조회
      final memos = await _getMemosByNoteIdUseCase(noteId);

      state = state.copyWith(
        note: note,
        todos: todos,
        memos: memos,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '노트 정보를 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 할일 완료/미완료 토글
  Future<void> toggleTodoComplete(String todoId) async {
    try {
      await _toggleTodoCompleteUseCase(todoId);

      // 현재 노트의 할일 목록 다시 로드
      if (state.note != null) {
        final todos = await _getTodosByNoteIdUseCase(state.note!.id);
        state = state.copyWith(todos: todos);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '할일 상태 변경에 실패했습니다: $e');
    }
  }

  /// 할일 날짜 이동
  Future<void> moveTodoToDate(String todoId, DateTime newDate) async {
    try {
      await _moveTodoToDateUseCase(todoId, newDate);

      // 현재 노트의 할일 목록 다시 로드
      if (state.note != null) {
        final todos = await _getTodosByNoteIdUseCase(state.note!.id);
        state = state.copyWith(todos: todos);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '할일 날짜 이동에 실패했습니다: $e');
    }
  }

  /// 할일 삭제
  Future<void> deleteTodo(String todoId) async {
    try {
      await _deleteTodoUseCase(todoId);

      // 현재 노트의 할일 목록 다시 로드
      if (state.note != null) {
        final todos = await _getTodosByNoteIdUseCase(state.note!.id);
        state = state.copyWith(todos: todos);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '할일 삭제에 실패했습니다: $e');
    }
  }

  /// 노트 그룹 접기/펼치기
  void toggleNoteExpanded(String noteId) {
    final newExpandedNotes = Set<String>.from(state.expandedNotes);
    if (newExpandedNotes.contains(noteId)) {
      newExpandedNotes.remove(noteId);
    } else {
      newExpandedNotes.add(noteId);
    }
    state = state.copyWith(expandedNotes: newExpandedNotes);
  }

  /// 날짜 그룹 접기/펼치기
  void toggleDateExpanded(String noteId, String date) {
    final newExpandedDates = Map<String, Set<String>>.from(state.expandedDates);

    if (!newExpandedDates.containsKey(noteId)) {
      newExpandedDates[noteId] = <String>{};
    }

    final dateSet = Set<String>.from(newExpandedDates[noteId]!);
    if (dateSet.contains(date)) {
      dateSet.remove(date);
    } else {
      dateSet.add(date);
    }

    newExpandedDates[noteId] = dateSet;
    state = state.copyWith(expandedDates: newExpandedDates);
  }

  /// 탭 전환 (0: 할일, 1: 메모)
  void switchTab(int tabIndex) {
    state = state.copyWith(selectedTab: tabIndex);
  }
}

final noteDetailProvider = StateNotifierProvider.family<NoteDetailNotifier, NoteDetailState, String>((ref, noteId) {
  final notifier = NoteDetailNotifier(
    getNoteByIdUseCase: getIt<GetNoteByIdUseCase>(),
    getTodosByNoteIdUseCase: getIt<GetTodosByNoteIdUseCase>(),
    toggleTodoCompleteUseCase: getIt<ToggleTodoCompleteUseCase>(),
    moveTodoToDateUseCase: getIt<MoveTodoToDateUseCase>(),
    deleteTodoUseCase: getIt<DeleteTodoUseCase>(),
    updateTodoUseCase: getIt<UpdateTodoUseCase>(),
    getMemosByNoteIdUseCase: getIt<GetMemosByNoteIdUseCase>(),
  );

  // 초기 로드
  notifier.loadNoteDetail(noteId);

  return notifier;
});