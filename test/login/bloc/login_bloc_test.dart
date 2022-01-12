import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
  });

  group('LoginBloc 검증 | ', () {
    test('최초 state가 LoginState인지', () {
      final loginBloc = LoginBloc(
        authenticationRepository: authenticationRepository,
      );
      expect(loginBloc.state, const LoginState());
    });

    group('LoginSubmitted 이벤트 |', () {
      blocTest<LoginBloc, LoginState>(
        'login 성공 시 submissionInProgress, submissionSuccess을 발생 ',
        setUp: () {
          when(
            () => authenticationRepository.logIn(
              username: 'deokhyeon',
              password: '1234',
            ),
          ).thenAnswer((_) => Future.value('deokhyeon'));
        },
        build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('deokhyeon'))
            ..add(const LoginPasswordChanged('1234'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('deokhyeon'),
            status: FormzStatus.invalid,
          ),
          LoginState(
            username: Username.dirty('deokhyeon'),
            password: Password.dirty('1234'),
            status: FormzStatus.valid,
          ),
          LoginState(
            username: Username.dirty('deokhyeon'),
            password: Password.dirty('1234'),
            status: FormzStatus.submissionInProgress,
          ),
          LoginState(
            username: Username.dirty('deokhyeon'),
            password: Password.dirty('1234'),
            status: FormzStatus.submissionSuccess,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'login 실패 시 submissionInProgress, submissionFailure 발생 ',
        setUp: () {
          when(
            () => authenticationRepository.logIn(
              username: 'username',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('username'),
            status: FormzStatus.invalid,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: FormzStatus.valid,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: FormzStatus.submissionInProgress,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: FormzStatus.submissionFailure,
          ),
        ],
      );
    });
  });
}
