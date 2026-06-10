import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  final String phone;

  const ProfileUpdateRequested({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}
