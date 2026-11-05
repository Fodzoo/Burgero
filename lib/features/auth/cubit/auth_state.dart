
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthSignupSuccess extends AuthState {
  final bool hasSession;

  AuthSignupSuccess({required this.hasSession});
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
