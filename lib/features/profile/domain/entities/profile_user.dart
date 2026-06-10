import 'package:equatable/equatable.dart';

class ProfileUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int wonCount;
  final int soldCount;
  final int bidsCount;

  const ProfileUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.wonCount,
    required this.soldCount,
    required this.bidsCount,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || name.trim().isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    wonCount,
    soldCount,
    bidsCount,
  ];
}
