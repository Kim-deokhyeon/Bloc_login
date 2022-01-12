// ignore_for_file: prefer_const_constructors
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const username = 'mock-username';
  const password = 'mock-password';
  group('LoginEvent', () {
    group('LoginUsernameChanged | ', () {
      test('value 비교', () {
        expect(LoginUsernameChanged(username), LoginUsernameChanged(username));
      });
    });

    group('LoginPasswordChanged | ', () {
      test('value 비교', () {
        expect(LoginPasswordChanged(password), LoginPasswordChanged(password));
      });
    });

    group('LoginSubmitted | ', () {
      test('value 비교', () {
        expect(LoginSubmitted(), LoginSubmitted());
      });
    });
  });
}
