import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../../profile/domain/usecases/has_phone_number_usecase.dart';
import '../../../domain/usecases/post_auction_usecase.dart';
import 'post_auction_event.dart';
import 'post_auction_state.dart';

class PostAuctionBloc extends Bloc<PostAuctionEvent, PostAuctionState> {
  final PostAuctionUseCase postAuctionUseCase;
  final HasPhoneNumberUseCase hasPhoneNumberUseCase;

  PostAuctionBloc({
    required this.postAuctionUseCase,
    required this.hasPhoneNumberUseCase,
  }) : super(const PostAuctionInitial()) {
    on<PostAuctionSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    PostAuctionSubmitted event,
    Emitter<PostAuctionState> emit,
  ) async {
    emit(const PostAuctionLoading());

    try {
      final hasPhone = await hasPhoneNumberUseCase(const NoParams());

      if (!hasPhone) {
        emit(
          const PostAuctionError(
            'Please add your phone number before posting an auction.',
          ),
        );
        return;
      }

      final result = await postAuctionUseCase(
        PostAuctionParams(
          title: event.title,
          category: event.category,
          currencyCode: event.currencyCode,
          startingPrice: event.startingPrice,
          duration: event.duration,
          localImagePaths: event.localImagePaths,
        ),
      );

      result.fold(
        (failure) => emit(PostAuctionError(failure.message)),
        (auctionId) => emit(PostAuctionSuccess(auctionId)),
      );
    } catch (_) {
      emit(
        const PostAuctionError(
          'Failed to verify your profile. Please try again.',
        ),
      );
    }
  }
}
