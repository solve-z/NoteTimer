import 'package:get_it/get_it.dart';
import 'package:note_timer/data/repository_impl/auth_repository_impl.dart';
import 'package:note_timer/domain/repository/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Auth Repository
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
}
