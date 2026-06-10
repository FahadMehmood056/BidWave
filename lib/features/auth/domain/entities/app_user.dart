import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, name, email, phone];
}
