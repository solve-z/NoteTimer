import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/data_source/remote/auth_data_source.dart';
import '../../data/data_source/local_storage/note_local_data_source.dart';
import '../../data/data_source/local_storage/focus_record_local_data_source.dart';
import '../../data/repository_impl/auth_repository_impl.dart';
import '../../data/repository_impl/note_repository_impl.dart';
import '../../data/repository_impl/focus_record_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/note_repository.dart';
import '../../domain/repository/focus_record_repository.dart';
import '../../domain/model/note_model.dart';
import '../../domain/model/focus_record_model.dart';
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
}
