// ignore_for_file: prefer_const_constructors
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationEvent', () {
    group('로그아웃', () {
      test('value 비교', () {
        expect(
          AuthenticationLogoutRequested(),
          AuthenticationLogoutRequested(),
        );
      });
    });

    group('Authentication Status 변경 이벤트', () {
      test('value 비교', () {
        expect(
          AuthenticationStatusChanged(AuthenticationStatus.unknown),
          AuthenticationStatusChanged(AuthenticationStatus.unknown),
        );
      });
    });
  });
}
