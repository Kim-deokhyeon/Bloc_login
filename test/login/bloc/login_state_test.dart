// ignore_for_file: prefer_const_constructors
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

void main() {
  const username = Username.dirty('username');
  const password = Password.dirty('password');
  group('LoginState', () {
    test('value 비교', () {
      expect(LoginState(), LoginState());
    });

    test('어느 값도 넘어가지 않을 시 동일한 객체를 반환하는지 검증', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('status가 넘어갈 때 반환 되는 객체가 업데이트 되는지 검증', () {
      expect(
        LoginState().copyWith(status: FormzStatus.pure),
        LoginState(status: FormzStatus.pure),
      );
    });

    test('username이 넘어갈 때 반환 되는 객체가 업데이트 되는지 검증', () {
      expect(
        LoginState().copyWith(username: username),
        LoginState(username: username),
      );
    });

    test('password가 넘어갈 때 반환 되는 객체가 업데이트 되는지 검증', () {
      expect(
        LoginState().copyWith(password: password),
        LoginState(password: password),
      );
    });
  });
}
