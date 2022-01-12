import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const user = User('id');
  late AuthenticationRepository authenticationRepository;
  late UserRepository userRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    when(() => authenticationRepository.status)
        .thenAnswer((_) => const Stream.empty());
    userRepository = MockUserRepository();
  });

  group('AuthenticationBloc 테스트 | ', () {
    test('AuthBloc 생성 시 inital State는 unknown 이다', () {
      final authenticationBloc = AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      );
      expect(authenticationBloc.state, const AuthenticationState.unknown());
      authenticationBloc.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Bloc의 status가 unauthenticated 일 때, unauthenticated을 Stream으로 보낸다',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unauthenticated),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Bloc의 status가 authenticated 일 때, authenticated을 Stream으로 보낸다',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.authenticated),
        );
        when(() => userRepository.getUser()).thenAnswer((_) async => user);
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );
  });

  group('AuthenticationBloc 상태 변경 테스트 | ', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'state가 authenticated 일 때 status에 authenticated을 Stream으로 전달한다.',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.authenticated),
        );
        when(() => userRepository.getUser()).thenAnswer((_) async => user);
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'status가 unauthenticated 일 때 status에 unauthenticated을 Stream으로 전달한다.',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unauthenticated),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.unauthenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'status가 authenticated지만 getUser가 실패 시, '
      'unauthenticated를 Stream으로 전달한다',
      setUp: () {
        when(() => userRepository.getUser()).thenThrow(Exception('oops'));
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'status가 authenticated지만 getUser가 null을 반환 시, '
      'unauthenticated를 Stream으로 전달한다',
      setUp: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => null);
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'status가 unknown 일 때 status에 unknown Stream으로 전달한다.',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unknown),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.unknown),
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unknown(),
      ],
    );
  });

  group('AuthenticationBloc 로그아웃 테스트 | ', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'AuthenticationLogoutRequested 이벤트가 추가되면 '
      'authenticationRepository에 로그아웃을 요청한다.',
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      verify: (_) {
        verify(() => authenticationRepository.logOut()).called(1);
      },
    );
  });
}
