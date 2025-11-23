import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/model/note_model.dart';
import '../../../domain/usecase/note/get_all_active_notes_usecase.dart';
import '../../../domain/usecase/note/get_all_archived_notes_usecase.dart';
import '../../../domain/usecase/note/create_note_usecase.dart';
import '../../../domain/usecase/note/update_note_usecase.dart';
import '../../../domain/usecase/note/delete_note_usecase.dart';
import '../../../domain/usecase/note/archive_note_usecase.dart';
import '../../../domain/usecase/note/unarchive_note_usecase.dart';
import '../../../domain/usecase/note/toggle_pin_note_usecase.dart';
import '../../../domain/usecase/note/toggle_select_for_today_usecase.dart';
import '../../../domain/usecase/note/update_note_order_usecase.dart';
import 'note_list_state.dart';

class NoteListNotifier extends StateNotifier<NoteListState> {
  final GetAllActiveNotesUseCase _getAllActiveNotesUseCase;
  final GetAllArchivedNotesUseCase _getAllArchivedNotesUseCase;
  final CreateNoteUseCase _createNoteUseCase;
  final UpdateNoteUseCase _updateNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;
  final ArchiveNoteUseCase _archiveNoteUseCase;
  final UnarchiveNoteUseCase _unarchiveNoteUseCase;
  final TogglePinNoteUseCase _togglePinNoteUseCase;
  final ToggleSelectForTodayUseCase _toggleSelectForTodayUseCase;
  final UpdateNoteOrderUseCase _updateNoteOrderUseCase;

  NoteListNotifier({
    required GetAllActiveNotesUseCase getAllActiveNotesUseCase,
    required GetAllArchivedNotesUseCase getAllArchivedNotesUseCase,
    required CreateNoteUseCase createNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
    required ArchiveNoteUseCase archiveNoteUseCase,
    required UnarchiveNoteUseCase unarchiveNoteUseCase,
    required TogglePinNoteUseCase togglePinNoteUseCase,
    required ToggleSelectForTodayUseCase toggleSelectForTodayUseCase,
    required UpdateNoteOrderUseCase updateNoteOrderUseCase,
  })  : _getAllActiveNotesUseCase = getAllActiveNotesUseCase,
        _getAllArchivedNotesUseCase = getAllArchivedNotesUseCase,
        _createNoteUseCase = createNoteUseCase,
        _updateNoteUseCase = updateNoteUseCase,
        _deleteNoteUseCase = deleteNoteUseCase,
        _archiveNoteUseCase = archiveNoteUseCase,
        _unarchiveNoteUseCase = unarchiveNoteUseCase,
        _togglePinNoteUseCase = togglePinNoteUseCase,
        _toggleSelectForTodayUseCase = toggleSelectForTodayUseCase,
        _updateNoteOrderUseCase = updateNoteOrderUseCase,
        super(NoteListState());

  /// 사용중 노트 로드
  Future<void> loadActiveNotes() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final notes = await _getAllActiveNotesUseCase();
      state = state.copyWith(activeNotes: notes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '노트를 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 보관함 노트 로드
  Future<void> loadArchivedNotes() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final notes = await _getAllArchivedNotesUseCase();
      state = state.copyWith(archivedNotes: notes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '보관함을 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 노트 추가
  Future<void> createNote(NoteModel note) async {
    try {
      await _createNoteUseCase(note);
      await loadActiveNotes();
    } catch (e) {
      state = state.copyWith(errorMessage: '노트 추가에 실패했습니다: $e');
    }
  }

  /// 노트 수정
  Future<void> updateNote(NoteModel note) async {
    try {
      await _updateNoteUseCase(note);
      if (state.selectedTab == 0) {
        await loadActiveNotes();
      } else {
        await loadArchivedNotes();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '노트 수정에 실패했습니다: $e');
    }
  }

  /// 노트 삭제
  Future<void> deleteNote(String noteId) async {
    try {
      await _deleteNoteUseCase(noteId);
      if (state.selectedTab == 0) {
        await loadActiveNotes();
      } else {
        await loadArchivedNotes();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '노트 삭제에 실패했습니다: $e');
    }
  }

  /// 노트 보관
  Future<void> archiveNote(String noteId) async {
    try {
      await _archiveNoteUseCase(noteId);
      await loadActiveNotes();
    } catch (e) {
      state = state.copyWith(errorMessage: '노트 보관에 실패했습니다: $e');
    }
  }

  /// 보관 해제
  Future<void> unarchiveNote(String noteId) async {
    try {
      await _unarchiveNoteUseCase(noteId);
      await loadArchivedNotes();
    } catch (e) {
      state = state.copyWith(errorMessage: '보관 해제에 실패했습니다: $e');
    }
  }

  /// 고정 토글
  Future<void> togglePin(String noteId) async {
    try {
      await _togglePinNoteUseCase(noteId);
      if (state.selectedTab == 0) {
        await loadActiveNotes();
      } else {
        await loadArchivedNotes();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '고정 설정에 실패했습니다: $e');
    }
  }

  /// 오늘 사용 체크 토글
  Future<void> toggleSelectForToday(String noteId) async {
    try {
      await _toggleSelectForTodayUseCase(noteId);
      if (state.selectedTab == 0) {
        await loadActiveNotes();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '선택 설정에 실패했습니다: $e');
    }
  }

  /// 드래그 앤 드롭으로 순서 변경
  Future<void> updateOrder(int oldIndex, int newIndex) async {
    try {
      final notes = state.selectedTab == 0 ? state.activeNotes : state.archivedNotes;
      final reorderedNotes = List<NoteModel>.from(notes);

      // 고정된 노트 개수 확인
      final pinnedCount = reorderedNotes.where((n) => n.isPinned).length;

      // 고정되지 않은 노트가 고정된 노트보다 위로 올라가는 것을 방지
      if (oldIndex >= pinnedCount && newIndex < pinnedCount) {
        return; // 이동 불가
      }

      final item = reorderedNotes.removeAt(oldIndex);
      reorderedNotes.insert(newIndex, item);

      // 순서 업데이트
      final noteIds = reorderedNotes.map((n) => n.id).toList();
      await _updateNoteOrderUseCase(noteIds);

      if (state.selectedTab == 0) {
        await loadActiveNotes();
      } else {
        await loadArchivedNotes();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '순서 변경에 실패했습니다: $e');
    }
  }

  /// 탭 전환
  void switchTab(int tabIndex) {
    state = state.copyWith(selectedTab: tabIndex);
    if (tabIndex == 0) {
      loadActiveNotes();
    } else {
      loadArchivedNotes();
    }
  }
}

final noteListProvider = StateNotifierProvider<NoteListNotifier, NoteListState>((ref) {
  return NoteListNotifier(
    getAllActiveNotesUseCase: getIt<GetAllActiveNotesUseCase>(),
    getAllArchivedNotesUseCase: getIt<GetAllArchivedNotesUseCase>(),
    createNoteUseCase: getIt<CreateNoteUseCase>(),
    updateNoteUseCase: getIt<UpdateNoteUseCase>(),
    deleteNoteUseCase: getIt<DeleteNoteUseCase>(),
    archiveNoteUseCase: getIt<ArchiveNoteUseCase>(),
    unarchiveNoteUseCase: getIt<UnarchiveNoteUseCase>(),
    togglePinNoteUseCase: getIt<TogglePinNoteUseCase>(),
    toggleSelectForTodayUseCase: getIt<ToggleSelectForTodayUseCase>(),
    updateNoteOrderUseCase: getIt<UpdateNoteOrderUseCase>(),
  );
});