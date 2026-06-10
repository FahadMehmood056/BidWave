import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auction_repository.dart';

class PostAuctionUseCase implements UseCase<String, PostAuctionParams> {
  final AuctionRepository repository;

  PostAuctionUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(PostAuctionParams params) {
    return repository.postAuction(
      title: params.title,
      category: params.category,
      currencyCode: params.currencyCode,
      startingPrice: params.startingPrice,
      duration: params.duration,
      localImagePaths: params.localImagePaths,
    );
  }
}

class PostAuctionParams extends Equatable {
  final String title;
  final String category;
  final String currencyCode;
  final double startingPrice;
  final Duration duration;
  final List<String> localImagePaths;

  const PostAuctionParams({
    required this.title,
    required this.category,
    required this.currencyCode,
    required this.startingPrice,
    required this.duration,
    required this.localImagePaths,
  });

  @override
  List<Object?> get props => [
    title,
    category,
    currencyCode,
    startingPrice,
    duration,
    localImagePaths,
  ];
}
