import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final result = userCheck(username, password);
    await Future.delayed(
      const Duration(milliseconds: 300),
      result
          ? () => _controller.add(AuthenticationStatus.authenticated)
          : () => _controller.add(AuthenticationStatus.unauthenticated),
    );
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  bool userCheck(String username, String password) {
    final authId = 'Deokhyeon';
    final authPw = '1234';
    if (username == authId && password == authPw)
      return true;
    else
      return false;
  }

  void dispose() => _controller.close();
}
