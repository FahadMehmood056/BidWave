import 'package:equatable/equatable.dart';

class Bid extends Equatable {
  final String id;
  final String bidderId;
  final String bidderName;
  final double amount;
  final DateTime timestamp;

  const Bid({
    required this.id,
    required this.bidderId,
    required this.bidderName,
    required this.amount,
    required this.timestamp,
  });

  String get initials {
    final parts = bidderName.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || bidderName.trim().isEmpty) {
      return 'B';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  List<Object?> get props => [id, bidderId, bidderName, amount, timestamp];
}
