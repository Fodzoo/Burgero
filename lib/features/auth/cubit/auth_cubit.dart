import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    if (state is AuthLoading) return;

    emit(AuthLoading());

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      emit(AuthSuccess());
    } on AuthException catch (error) {
      emit(AuthFailure(error.message));
    } catch (_) {
      emit(AuthFailure('Something went wrong. Please try again.'));
    }
  }

  Future<void> signup({
    required String name,
    required String address,
    required String email,
    required String password,
  }) async {
    if (state is AuthLoading) return;

    emit(AuthLoading());

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'name': name.trim(), 'address': address.trim()},
      );

      if (response.user == null) {
        emit(AuthFailure('Account could not be created. Please try again.'));
        return;
      }

      emit(AuthSignupSuccess(hasSession: response.session != null));
    } on AuthException catch (error) {
      emit(AuthFailure(error.message));
    } catch (_) {
      emit(AuthFailure('Something went wrong. Please try again.'));
    }
  }

  void reset() {
    emit(AuthInitial());
  }
}
