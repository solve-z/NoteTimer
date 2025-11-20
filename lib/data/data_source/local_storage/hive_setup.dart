import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/model/user_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // TypeAdapter 등록
  Hive.registerAdapter(UserModelAdapter());

  // Box 열기
  await Hive.openBox<UserModel>('user');

  // TODO: 추가 모델 TypeAdapter 등록
  // 예시:
  // Hive.registerAdapter(TodoAdapter());
  // Hive.registerAdapter(NoteAdapter());
  // Hive.registerAdapter(TimerRecordAdapter());

  // TODO: 추가 Box 열기
  // await Hive.openBox<Todo>('todos');
  // await Hive.openBox<Note>('notes');
  // await Hive.openBox<TimerRecord>('timer_records');
}
