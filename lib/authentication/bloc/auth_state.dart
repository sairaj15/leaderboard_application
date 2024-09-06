part of 'auth_bloc.dart';

class AuthState {
  AuthState({
    required this.isAuthenticated,
    required this.isLoading,
  });

  final bool isAuthenticated;
  final bool isLoading;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
