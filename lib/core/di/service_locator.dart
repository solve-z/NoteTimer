import 'package:get_it/get_it.dart';
import '../../data/data_source/remote/auth_data_source.dart';
import '../../data/repository_impl/auth_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/auth/sign_in_with_google_usecase.dart';
import '../../domain/usecase/auth/sign_out_usecase.dart';
import '../../domain/usecase/auth/update_nickname_usecase.dart';
import '../../domain/usecase/auth/check_nickname_duplicate_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Data Source
  getIt.registerSingleton<AuthDataSource>(AuthDataSource());

  // Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      authDataSource: getIt<AuthDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerFactory(() => SignInWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => UpdateNicknameUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => CheckNicknameDuplicateUseCase(getIt<AuthRepository>()));
}
