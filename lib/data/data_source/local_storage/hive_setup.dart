import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/user_model.dart';
import '../../../domain/model/note_model.dart';
import '../../../domain/model/focus_record_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // TypeAdapter 등록
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(FocusRecordModelAdapter());

  // Box 열기
  await Hive.openBox<UserModel>('user');
  await Hive.openBox<NoteModel>('notes');
  await Hive.openBox<FocusRecordModel>('focus_records');

  // TODO: 추가 모델 TypeAdapter 등록
  // 예시:
  // Hive.registerAdapter(TodoAdapter());

  // TODO: 추가 Box 열기
  // await Hive.openBox<Todo>('todos');
}
