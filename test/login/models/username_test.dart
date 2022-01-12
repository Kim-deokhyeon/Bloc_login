// ignore_for_file: prefer_const_constructors
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const usernameString = 'mock-username';
  group('Username', () {
    group('생성자 | ', () {
      test('pure가 올바른 객체를 생성하는지 검증', () {
        final username = Username.pure();
        expect(username.value, '');
        expect(username.pure, true);
      });

      test('dirty가 올바른 객체를 생성하는지 검증', () {
        final username = Username.dirty(usernameString);
        expect(username.value, usernameString);
        expect(username.pure, false);
      });
    });

    group('유효성 | ', () {
      test('username이 비어있을 때 empty error인지 검증', () {
        expect(
          Username.dirty('').error,
          UsernameValidationError.empty,
        );
      });

      test('username이 비어있지 않을 때 유효한지 검증', () {
        expect(
          Username.dirty(usernameString).error,
          isNull,
        );
      });
    });
  });
}
