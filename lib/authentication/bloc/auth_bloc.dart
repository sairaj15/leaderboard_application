import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaderboard_application/authentication/model/user_model.dart';
import 'package:leaderboard_application/authentication/service/auth_firebase_service.dart';
import 'package:leaderboard_application/authentication/service/auth_firestore_service.dart';
import 'package:leaderboard_application/shared/show_snackbar.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(AuthState(
          isAuthenticated: false,
          isLoading: false,
        )) {
    on<AuthEventCreateAccount>(_onAuthEventCreateAccount);
    on<AuthEventLogin>(_onAuthEventLogin);
    on<AuthEventLogout>(_onAuthEventLogout);
    on<AuthEventCreateUser>(_onAuthEventCreateUser);
    on<AuthEventPromoteToAdmin>(_onAuthEventPromoteToAdmin);
  }

  final _authService = AuthFirebaseService();
  final _firestoreService = AuthFirestoreService();

  FutureOr<void> _onAuthEventCreateAccount(
    AuthEventCreateAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final response = await _authService.createAccount(
      email: event.emailAddress,
      password: event.password,
      isAdmin: event.isAdmin,
    );
    response.fold(
      (l) {
        emit(state.copyWith(isAuthenticated: false, isLoading: false));
      },
      (r) {},
    );
  }

  FutureOr<void> _onAuthEventLogin(
      AuthEventLogin event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await _authService.login(
      email: event.emailAddress,
      password: event.password,
    );
    response.fold(
      (l) {
        emit(state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        ));
        showSnackbar('Something went wrong!');
      },
      (r) {
        emit(state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        ));
      },
    );
  }

  FutureOr<void> _onAuthEventLogout(
      AuthEventLogout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await _authService.logout();
    response.fold(
      (l) {
        showSnackbar(l);
      },
      (r) {
        showSnackbar('Logout Successful!');
        emit(state.copyWith(isAuthenticated: false, isLoading: false));
      },
    );
  }

  FutureOr<void> _onAuthEventCreateUser(
    AuthEventCreateUser event,
    Emitter<AuthState> emit,
  ) async {
    await _firestoreService.createUser(
      userModel: event.authModel,
    );
  }

  FutureOr<void> _onAuthEventPromoteToAdmin(
    AuthEventPromoteToAdmin event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: event.emailAddress)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .update({'isAdmin': true, 'role': 'admin'});

        showSnackbar('User promoted to admin!');
      } else {
        showSnackbar('Failed to promote user!');
      }
    } catch (e) {
      showSnackbar('Failed to promote user!');
    }
  }
}
