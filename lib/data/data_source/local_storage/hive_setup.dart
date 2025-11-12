import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // TODO: TypeAdapter 등록
  // 예시:
  // Hive.registerAdapter(TodoAdapter());
  // Hive.registerAdapter(NoteAdapter());
  // Hive.registerAdapter(TimerRecordAdapter());

  // TODO: Box 열기
  // await Hive.openBox<Todo>('todos');
  // await Hive.openBox<Note>('notes');
  // await Hive.openBox<TimerRecord>('timer_records');
}
