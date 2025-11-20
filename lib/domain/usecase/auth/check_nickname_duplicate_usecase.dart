import '../../repository/auth_repository.dart';

class CheckNicknameDuplicateUseCase {
  final AuthRepository _repository;

  CheckNicknameDuplicateUseCase(this._repository);

  Future<bool> call(String nickname) async {
    return await _repository.checkNicknameDuplicate(nickname);
  }
}
