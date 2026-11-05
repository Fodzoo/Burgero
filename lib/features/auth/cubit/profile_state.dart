abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String address;

  ProfileLoaded({
    required this.name,
    required this.email,
    required this.address,
  });
}

class ProfileSaving extends ProfileState {}

class ProfileSaveSuccess extends ProfileState {
  final String name;
  final String email;
  final String address;

  ProfileSaveSuccess({
    required this.name,
    required this.email,
    required this.address,
  });
}

class ProfileLoggingOut extends ProfileState {}

class ProfileLogoutSuccess extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}