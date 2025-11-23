import '../../../domain/model/note_model.dart';
import '../../../domain/model/todo_model.dart';
import '../../../domain/model/memo_model.dart';

class NoteDetailState {
  final NoteModel? note;
  final List<TodoModel> todos;
  final List<MemoModel> memos;
  final int selectedTab;
  final Set<String> expandedNotes;
  final Map<String, Set<String>> expandedDates;
  final bool isLoading;
  final String? errorMessage;

  NoteDetailState({
    this.note,
    this.todos = const [],
    this.memos = const [],
    this.selectedTab = 0,
    this.expandedNotes = const {},
    this.expandedDates = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  NoteDetailState copyWith({
    NoteModel? note,
    List<TodoModel>? todos,
    List<MemoModel>? memos,
    int? selectedTab,
    Set<String>? expandedNotes,
    Map<String, Set<String>>? expandedDates,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NoteDetailState(
      note: note ?? this.note,
      todos: todos ?? this.todos,
      memos: memos ?? this.memos,
      selectedTab: selectedTab ?? this.selectedTab,
      expandedNotes: expandedNotes ?? this.expandedNotes,
      expandedDates: expandedDates ?? this.expandedDates,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}