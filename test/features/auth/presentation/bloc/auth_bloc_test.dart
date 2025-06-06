import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:remote_team_task_board_flutter/core/error/failures.dart';
import 'package:remote_team_task_board_flutter/core/usecases/usecase.dart';
import 'package:remote_team_task_board_flutter/features/auth/domain/entities/user.dart';
import 'package:remote_team_task_board_flutter/features/auth/domain/usecases/get_current_user.dart';
import 'package:remote_team_task_board_flutter/features/auth/domain/usecases/login.dart';
import 'package:remote_team_task_board_flutter/features/auth/domain/usecases/logout.dart';
import 'package:remote_team_task_board_flutter/features/auth/domain/usecases/register.dart';
import 'package:remote_team_task_board_flutter/features/auth/presentation/bloc/auth_bloc.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([Login, Register, GetCurrentUser, Logout])
void main() {
  late AuthBloc authBloc;
  late MockLogin mockLogin;
  late MockRegister mockRegister;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockLogout mockLogout;

  setUp(() {
    mockLogin = MockLogin();
    mockRegister = MockRegister();
    mockGetCurrentUser = MockGetCurrentUser();
    mockLogout = MockLogout();

    authBloc = AuthBloc(
      login: mockLogin,
      register: mockRegister,
      getCurrentUser: mockGetCurrentUser,
      logout: mockLogout,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    final tUser = User(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
    );

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    group('CheckAuthStatusEvent', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when user is authenticated',
        build: () {
          when(
            mockGetCurrentUser(const NoParams()),
          ).thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(CheckAuthStatusEvent()),
        expect: () => [AuthLoading(), AuthAuthenticated(user: tUser)],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when user is not authenticated',
        build: () {
          when(
            mockGetCurrentUser(const NoParams()),
          ).thenAnswer((_) async => Left(CacheFailure('Cache failure')));
          return authBloc;
        },
        act: (bloc) => bloc.add(CheckAuthStatusEvent()),
        expect: () => [AuthLoading(), AuthUnauthenticated()],
      );
    });

    group('LoginEvent', () {
      const tEmail = 'test@example.com';
      const tPassword = 'password123';

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when login is successful',
        build: () {
          when(
            mockLogin(const LoginParams(email: tEmail, password: tPassword)),
          ).thenAnswer((_) async => const Right('token'));
          when(
            mockGetCurrentUser(const NoParams()),
          ).thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act:
            (bloc) =>
                bloc.add(const LoginEvent(email: tEmail, password: tPassword)),
        expect: () => [AuthLoading(), AuthAuthenticated(user: tUser)],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when login fails',
        build: () {
          when(
            mockLogin(const LoginParams(email: tEmail, password: tPassword)),
          ).thenAnswer((_) async => Left(ServerFailure('Server failure')));
          return authBloc;
        },
        act:
            (bloc) =>
                bloc.add(const LoginEvent(email: tEmail, password: tPassword)),
        expect:
            () => [AuthLoading(), const AuthError(message: 'Server failure')],
      );
    });

    group('RegisterEvent', () {
      const tEmail = 'test@example.com';
      const tPassword = 'password123';
      const tName = 'Test User';

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when registration is successful',
        build: () {
          when(
            mockRegister(
              const RegisterParams(
                email: tEmail,
                password: tPassword,
                name: tName,
              ),
            ),
          ).thenAnswer((_) async => const Right('token'));
          when(
            mockGetCurrentUser(const NoParams()),
          ).thenAnswer((_) async => Right(tUser));
          return authBloc;
        },
        act:
            (bloc) => bloc.add(
              const RegisterEvent(
                email: tEmail,
                password: tPassword,
                name: tName,
              ),
            ),
        expect: () => [AuthLoading(), AuthAuthenticated(user: tUser)],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when registration fails',
        build: () {
          when(
            mockRegister(
              const RegisterParams(
                email: tEmail,
                password: tPassword,
                name: tName,
              ),
            ),
          ).thenAnswer((_) async => Left(ServerFailure('Server failure')));
          return authBloc;
        },
        act:
            (bloc) => bloc.add(
              const RegisterEvent(
                email: tEmail,
                password: tPassword,
                name: tName,
              ),
            ),
        expect:
            () => [AuthLoading(), const AuthError(message: 'Server failure')],
      );
    });

    group('LogoutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when logout is successful',
        build: () {
          when(
            mockLogout(const NoParams()),
          ).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutEvent()),
        expect: () => [AuthLoading(), AuthUnauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when logout fails',
        build: () {
          when(
            mockLogout(const NoParams()),
          ).thenAnswer((_) async => Left(CacheFailure('Cache failure')));
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutEvent()),
        expect:
            () => [AuthLoading(), const AuthError(message: 'Cache failure')],
      );
    });
  });
}
