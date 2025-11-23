import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/data_source/remote/auth_data_source.dart';
import '../../data/data_source/local_storage/note_local_data_source.dart';
import '../../data/data_source/local_storage/focus_record_local_data_source.dart';
import '../../data/data_source/local_storage/todo_local_data_source.dart';
import '../../data/data_source/local_storage/memo_local_data_source.dart';
import '../../data/repository_impl/auth_repository_impl.dart';
import '../../data/repository_impl/note_repository_impl.dart';
import '../../data/repository_impl/focus_record_repository_impl.dart';
import '../../data/repository_impl/todo_repository_impl.dart';
import '../../data/repository_impl/memo_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/note_repository.dart';
import '../../domain/repository/focus_record_repository.dart';
import '../../domain/repository/todo_repository.dart';
import '../../domain/repository/memo_repository.dart';
import '../../domain/model/note_model.dart';
import '../../domain/model/focus_record_model.dart';
import '../../domain/model/todo_model.dart';
import '../../domain/model/memo_model.dart';
import '../../domain/usecase/auth/sign_in_with_google_usecase.dart';
import '../../domain/usecase/auth/sign_out_usecase.dart';
import '../../domain/usecase/auth/update_nickname_usecase.dart';
import '../../domain/usecase/auth/check_nickname_duplicate_usecase.dart';
import '../../domain/usecase/auth/get_current_user_usecase.dart';
import '../../domain/usecase/note/get_pinned_notes_usecase.dart';
import '../../domain/usecase/note/get_notes_by_date_usecase.dart';
import '../../domain/usecase/note/get_all_active_notes_usecase.dart';
import '../../domain/usecase/note/get_all_archived_notes_usecase.dart';
import '../../domain/usecase/note/create_note_usecase.dart';
import '../../domain/usecase/note/update_note_usecase.dart';
import '../../domain/usecase/note/delete_note_usecase.dart';
import '../../domain/usecase/note/archive_note_usecase.dart';
import '../../domain/usecase/note/unarchive_note_usecase.dart';
import '../../domain/usecase/note/toggle_pin_note_usecase.dart';
import '../../domain/usecase/note/toggle_select_for_today_usecase.dart';
import '../../domain/usecase/note/update_note_order_usecase.dart';
import '../../domain/usecase/note/reset_today_selection_usecase.dart';
import '../../domain/usecase/focus/get_records_by_date_usecase.dart';
import '../../domain/usecase/focus/get_total_focus_time_usecase.dart';
import '../../domain/usecase/focus_record/get_ongoing_focus_record_usecase.dart';
import '../../domain/usecase/focus_record/create_focus_record_usecase.dart';
import '../../domain/usecase/focus_record/update_focus_record_usecase.dart';
import '../../domain/usecase/focus_record/get_today_total_focus_time_by_note_usecase.dart';
import '../../domain/usecase/todo/get_todos_by_note_id_usecase.dart';
import '../../domain/usecase/todo/get_todos_by_note_and_date_usecase.dart';
import '../../domain/usecase/todo/create_todo_usecase.dart';
import '../../domain/usecase/todo/toggle_todo_complete_usecase.dart';
import '../../domain/usecase/todo/move_todo_to_date_usecase.dart';
import '../../domain/usecase/todo/delete_todo_usecase.dart';
import '../../domain/usecase/todo/update_todo_usecase.dart';
import '../../domain/usecase/memo/get_memos_by_note_id_usecase.dart';
import '../../domain/usecase/memo/create_memo_usecase.dart';
import '../../domain/usecase/note/get_note_by_id_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Data Source - Remote
  getIt.registerSingleton<AuthDataSource>(AuthDataSource());

  // Data Source - Local
  getIt.registerSingleton<NoteLocalDataSource>(
    NoteLocalDataSource(Hive.box<NoteModel>('notes')),
  );
  getIt.registerSingleton<FocusRecordLocalDataSource>(
    FocusRecordLocalDataSource(Hive.box<FocusRecordModel>('focus_records')),
  );
  getIt.registerSingleton<TodoLocalDataSource>(
    TodoLocalDataSource(Hive.box<TodoModel>('todos')),
  );
  getIt.registerSingleton<MemoLocalDataSource>(
    MemoLocalDataSource(Hive.box<MemoModel>('memos')),
  );

  // Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      authDataSource: getIt<AuthDataSource>(),
    ),
  );
  getIt.registerSingleton<NoteRepository>(
    NoteRepositoryImpl(getIt<NoteLocalDataSource>()),
  );
  getIt.registerSingleton<FocusRecordRepository>(
    FocusRecordRepositoryImpl(getIt<FocusRecordLocalDataSource>()),
  );
  getIt.registerSingleton<TodoRepository>(
    TodoRepositoryImpl(getIt<TodoLocalDataSource>()),
  );
  getIt.registerSingleton<MemoRepository>(
    MemoRepositoryImpl(getIt<MemoLocalDataSource>()),
  );

  // Use Cases - Auth
  getIt.registerFactory(() => SignInWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => UpdateNicknameUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => CheckNicknameDuplicateUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetCurrentUserUseCase(getIt<AuthRepository>()));

  // Use Cases - Note
  getIt.registerFactory(() => GetPinnedNotesUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => GetNotesByDateUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => GetAllActiveNotesUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => GetAllArchivedNotesUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => CreateNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => UpdateNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => DeleteNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => ArchiveNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => UnarchiveNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => TogglePinNoteUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => ToggleSelectForTodayUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => UpdateNoteOrderUseCase(getIt<NoteRepository>()));
  getIt.registerFactory(() => ResetTodaySelectionUseCase(getIt<NoteRepository>()));

  // Use Cases - Focus
  getIt.registerFactory(() => GetRecordsByDateUseCase(getIt<FocusRecordRepository>()));
  getIt.registerFactory(() => GetTotalFocusTimeUseCase(getIt<FocusRecordRepository>()));

  // Use Cases - Focus Record (Timer)
  getIt.registerFactory(() => GetOngoingFocusRecordUseCase(getIt<FocusRecordRepository>()));
  getIt.registerFactory(() => CreateFocusRecordUseCase(getIt<FocusRecordRepository>()));
  getIt.registerFactory(() => UpdateFocusRecordUseCase(getIt<FocusRecordRepository>()));
  getIt.registerFactory(() => GetTodayTotalFocusTimeByNoteUseCase(getIt<FocusRecordRepository>()));

  // Use Cases - Todo
  getIt.registerFactory(() => GetTodosByNoteIdUseCase(getIt<TodoRepository>()));
  getIt.registerFactory(() => GetTodosByNoteAndDateUseCase(getIt<TodoRepository>()));
  getIt.registerFactory(() => CreateTodoUseCase(getIt<TodoRepository>()));
  getIt.registerFactory(() => ToggleTodoCompleteUseCase(getIt<TodoRepository>()));
  getIt.registerFactory(() => MoveTodoToDateUseCase(getIt<TodoRepository>()));
  getIt.registerFactory(() => DeleteTodoUseCase(getIt<TodoRepository>()));
  getIt.registerFactory(() => UpdateTodoUseCase(getIt<TodoRepository>()));

  // Use Cases - Memo
  getIt.registerFactory(() => GetMemosByNoteIdUseCase(getIt<MemoRepository>()));
  getIt.registerFactory(() => CreateMemoUseCase(getIt<MemoRepository>()));

  // Use Cases - Note (추가)
  getIt.registerFactory(() => GetNoteByIdUseCase(getIt<NoteRepository>()));
}
