import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // TODO: 나중에 Repository, UseCase 등록
  // 예시:
  // getIt.registerSingleton<TodoRepository>(TodoRepositoryImpl());
  // getIt.registerFactory(() => GetTodoUseCase(getIt()));
}
