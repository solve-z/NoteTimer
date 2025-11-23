import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/user_model.dart';
import '../../../domain/model/note_model.dart';
import '../../../domain/model/focus_record_model.dart';
import '../../../domain/model/todo_model.dart';
import '../../../domain/model/memo_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // TypeAdapter 등록
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(FocusRecordModelAdapter());
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(MemoModelAdapter());

  // Box 열기
  await Hive.openBox<UserModel>('user');
  await Hive.openBox<NoteModel>('notes');
  await Hive.openBox<FocusRecordModel>('focus_records');
  await Hive.openBox<TodoModel>('todos');
  await Hive.openBox<MemoModel>('memos');
}
