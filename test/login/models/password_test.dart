// ignore_for_file: prefer_const_constructors
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const passwordString = 'mock-password';
  group('Password', () {
    group('생성자 | ', () {
      test('pure가 올바른 객체를 생성하는지 검증', () {
        final password = Password.pure();
        expect(password.value, '');
        expect(password.pure, true);
      });

      test('dirty가 올바른 객체를 생성하는지 검증', () {
        final password = Password.dirty(passwordString);
        expect(password.value, passwordString);
        expect(password.pure, false);
      });
    });

    group('유효성 | ', () {
      test('password가 비어있을 때 empty error인지 검증', () {
        expect(
          Password.dirty('').error,
          PasswordValidationError.empty,
        );
      });

      test('password가 비어있지 않을 때 유효한지 검증', () {
        expect(
          Password.dirty(passwordString).error,
          isNull,
        );
      });
    });
  });
}
