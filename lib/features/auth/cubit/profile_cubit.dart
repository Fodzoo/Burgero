import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final supabase = Supabase.instance.client;

  // Load profile data
  Future<void> loadProfile() async {
    emit(ProfileLoading());

    try {
      final user = supabase.auth.currentUser;

      print('========== PROFILE DEBUG ==========');
      print('CURRENT USER ID: ${user?.id}');
      print('USER EMAIL: ${user?.email}');
      print('USER METADATA: ${user?.userMetadata}');
      print('===================================');

      if (user == null) {
        emit(ProfileFailure('User is not logged in.'));
        return;
      }

      emit(
        ProfileLoaded(
          name: user.userMetadata?['name']?.toString() ?? '',
          email: user.email ?? '',
          address: user.userMetadata?['address']?.toString() ?? '',
        ),
      );
    } catch (error) {
      print('PROFILE LOAD ERROR: $error');
      emit(ProfileFailure('Failed to load profile.'));
    }
  }

  // Update profile data
  Future<void> updateProfile({
    required String name,
    required String address,
  }) async {
    emit(ProfileSaving());

    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(data: {'name': name.trim(), 'address': address.trim()}),
      );

      final user = response.user;

      print('========== PROFILE UPDATE ==========');
      print('UPDATED METADATA: ${user?.userMetadata}');
      print('====================================');

      if (user == null) {
        emit(ProfileFailure('Failed to update profile.'));
        return;
      }

      emit(
        ProfileSaveSuccess(
          name: user.userMetadata?['name']?.toString() ?? name.trim(),
          email: user.email ?? '',
          address: user.userMetadata?['address']?.toString() ?? address.trim(),
        ),
      );
    } on AuthException catch (error) {
      print('PROFILE UPDATE ERROR: ${error.message}');
      emit(ProfileFailure(error.message));
    } catch (error) {
      print('PROFILE UPDATE ERROR: $error');
      emit(ProfileFailure('Something went wrong. Please try again.'));
    }
  }

  // Logout
  Future<void> logout() async {
    emit(ProfileLoggingOut());

    try {
      await supabase.auth.signOut();
      emit(ProfileLogoutSuccess());
    } on AuthException catch (error) {
      emit(ProfileFailure(error.message));
    } catch (error) {
      print('LOGOUT ERROR: $error');
      emit(ProfileFailure('Failed to logout. Please try again.'));
    }
  }
}
