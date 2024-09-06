part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventCreateAccount extends AuthEvent {
  AuthEventCreateAccount({
    required this.emailAddress,
    required this.password,
    required this.isAdmin,
  });

  final String emailAddress;
  final String password;
  final bool isAdmin;
}

class AuthEventLogin extends AuthEvent {
  const AuthEventLogin({
    required this.emailAddress,
    required this.password,
  });

  final String emailAddress;
  final String password;
}

class AuthEventLogout extends AuthEvent {}

class AuthEventInitialize extends AuthEvent {}

class AuthEventCreateUser extends AuthEvent {
  const AuthEventCreateUser({
    required this.authModel,
  });
  final UserModel authModel;
}

class AuthEventPromoteToAdmin extends AuthEvent {
  AuthEventPromoteToAdmin({
    required this.emailAddress,
  });

  final String emailAddress;
}
