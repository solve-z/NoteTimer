/// 노트 추가/수정 폼 상태
class NoteFormState {
  final String noteTitle;
  final int selectedColor;
  final bool isEditMode;
  final String? editingNoteId;
  final bool isSaving;
  final String? errorMessage;

  const NoteFormState({
    this.noteTitle = '',
    required this.selectedColor,
    this.isEditMode = false,
    this.editingNoteId,
    this.isSaving = false,
    this.errorMessage,
  });

  /// 초기 상태 (추가 모드)
  factory NoteFormState.initial() {
    return const NoteFormState(
      noteTitle: '',
      selectedColor: 0xFFFFDADA, // 기본 색상
      isEditMode: false,
      editingNoteId: null,
      isSaving: false,
      errorMessage: null,
    );
  }

  /// 수정 모드 상태
  factory NoteFormState.edit({
    required String noteId,
    required String noteTitle,
    required int selectedColor,
  }) {
    return NoteFormState(
      noteTitle: noteTitle,
      selectedColor: selectedColor,
      isEditMode: true,
      editingNoteId: noteId,
      isSaving: false,
      errorMessage: null,
    );
  }

  NoteFormState copyWith({
    String? noteTitle,
    int? selectedColor,
    bool? isEditMode,
    String? editingNoteId,
    bool? isSaving,
    String? errorMessage,
  }) {
    return NoteFormState(
      noteTitle: noteTitle ?? this.noteTitle,
      selectedColor: selectedColor ?? this.selectedColor,
      isEditMode: isEditMode ?? this.isEditMode,
      editingNoteId: editingNoteId ?? this.editingNoteId,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}