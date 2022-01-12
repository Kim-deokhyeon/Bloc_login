// ignore_for_file: prefer_const_constructors
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AuthenticationState', () {
    group('AuthenticationState.unknown', () {
      test('value 비교', () {
        expect(
          AuthenticationState.unknown(),
          AuthenticationState.unknown(),
        );
      });
    });

    group('AuthenticationState.authenticated', () {
      test('value 비교', () {
        final user = MockUser();
        expect(
          AuthenticationState.authenticated(user),
          AuthenticationState.authenticated(user),
        );
      });
    });

    group('AuthenticationState.unauthenticated', () {
      test('value 비교', () {
        expect(
          AuthenticationState.unauthenticated(),
          AuthenticationState.unauthenticated(),
        );
      });
    });
  });
}
