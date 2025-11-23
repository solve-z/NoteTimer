import '../../../domain/model/note_model.dart';

class NoteListState {
  final List<NoteModel> activeNotes;
  final List<NoteModel> archivedNotes;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  NoteListState({
    this.activeNotes = const [],
    this.archivedNotes = const [],
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  NoteListState copyWith({
    List<NoteModel>? activeNotes,
    List<NoteModel>? archivedNotes,
    int? selectedTab,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NoteListState(
      activeNotes: activeNotes ?? this.activeNotes,
      archivedNotes: archivedNotes ?? this.archivedNotes,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}