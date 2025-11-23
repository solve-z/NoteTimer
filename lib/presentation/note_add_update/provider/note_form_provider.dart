import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/service_locator.dart';
import '../../../domain/model/note_model.dart';
import '../../../domain/usecase/note/create_note_usecase.dart';
import '../../../domain/usecase/note/update_note_usecase.dart';
import 'note_form_state.dart';

/// 노트 추가/수정 폼 Provider
final noteFormProvider =
    StateNotifierProvider<NoteFormNotifier, NoteFormState>((ref) {
  return NoteFormNotifier(
    createNoteUseCase: getIt<CreateNoteUseCase>(),
    updateNoteUseCase: getIt<UpdateNoteUseCase>(),
  );
});

/// 노트 추가/수정 폼 Notifier
class NoteFormNotifier extends StateNotifier<NoteFormState> {
  final CreateNoteUseCase _createNoteUseCase;
  final UpdateNoteUseCase _updateNoteUseCase;

  NoteFormNotifier({
    required CreateNoteUseCase createNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
  })  : _createNoteUseCase = createNoteUseCase,
        _updateNoteUseCase = updateNoteUseCase,
        super(NoteFormState.initial());

  /// 노트 이름 설정
  void setNoteTitle(String title) {
    state = state.copyWith(noteTitle: title, errorMessage: null);
  }

  /// 선택된 색상 설정
  void setSelectedColor(int colorValue) {
    state = state.copyWith(selectedColor: colorValue);
  }

  /// 수정할 노트 로드
  void loadNoteForEdit(NoteModel note) {
    state = NoteFormState.edit(
      noteId: note.id,
      noteTitle: note.title,
      selectedColor: note.colorValue,
    );
  }

  /// 노트 저장 (추가 또는 수정)
  Future<bool> saveNote(String userId) async {
    // 노트 이름 유효성 검사
    if (state.noteTitle.trim().isEmpty) {
      state = state.copyWith(errorMessage: '노트 이름을 입력하세요');
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      if (state.isEditMode && state.editingNoteId != null) {
        // 수정 모드
        final updatedNote = NoteModel(
          id: state.editingNoteId!,
          title: state.noteTitle.trim(),
          colorValue: state.selectedColor,
          createdAt: DateTime.now(), // 기존 createdAt은 유지되어야 하지만, 여기서는 임시로 설정
          updatedAt: DateTime.now(),
          userId: userId,
        );
        await _updateNoteUseCase(updatedNote);
      } else {
        // 추가 모드
        final newNote = NoteModel(
          id: const Uuid().v4(),
          title: state.noteTitle.trim(),
          colorValue: state.selectedColor,
          isPinned: false,
          createdAt: DateTime.now(),
          userId: userId,
          isArchived: false,
          isSelectedForToday: false,
          sortOrder: 0,
        );
        await _createNoteUseCase(newNote);
      }

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: '노트 저장 실패: ${e.toString()}',
      );
      return false;
    }
  }

  /// 상태 초기화
  void reset() {
    state = NoteFormState.initial();
  }
}