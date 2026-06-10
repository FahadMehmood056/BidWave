import 'package:bid_wave/core/constants/oauth_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auction_detail/data/datasources/bid_remote_data_source.dart';
import '../../features/auction_detail/data/repositories/bid_repository_impl.dart';
import '../../features/auction_detail/domain/repositories/bid_repository.dart';
import '../../features/auction_detail/domain/usecases/place_bid_usecase.dart';
import '../../features/auction_detail/domain/usecases/watch_auction_usecase.dart';
import '../../features/auction_detail/domain/usecases/watch_bids_usecase.dart';
import '../../features/auction_detail/presentation/bloc/auction_detail_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/google_sign_in_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/watch_auth_state_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auctions/data/datasources/auction_remote_data_source.dart';
import '../../features/auctions/data/repositories/auction_repository_impl.dart';
import '../../features/auctions/domain/repositories/auction_repository.dart';
import '../../features/auctions/domain/usecases/post_auction_usecase.dart';
import '../../features/auctions/domain/usecases/watch_live_auctions_usecase.dart';
import '../../features/auctions/domain/usecases/watch_my_auctions_usecase.dart';
import '../../features/auctions/presentation/bloc/my_auction_bloc/my_auctions_bloc.dart';
import '../../features/auctions/presentation/bloc/post_auction_bloc/post_auction_bloc.dart';
import '../../features/bids/data/datasources/my_bids_remote_data_source.dart';
import '../../features/bids/data/repositories/my_bids_repository_impl.dart';
import '../../features/bids/domain/repositories/my_bids_repository.dart';
import '../../features/bids/domain/usecases/watch_my_bids_usecase.dart';
import '../../features/bids/presentation/bloc/my_bids_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/notifications/domain/usecases/watch_unread_notifications_count_usecase.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_cached_profile_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/has_phone_number_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../services/fcm_token_service.dart';
import '../services/local_notification_service.dart';
import '../services/notification_manager.dart';
import '../storage/local_user_storage.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import '../../features/notifications/domain/usecases/watch_notifications_usecase.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/winner/data/datasources/winner_remote_data_source.dart';
import '../../features/winner/data/repositories/winner_repository_impl.dart';
import '../../features/winner/domain/repositories/winner_repository.dart';
import '../../features/winner/domain/usecases/get_winner_detail_usecase.dart';
import '../../features/winner/domain/usecases/watch_won_auctions_usecase.dart';
import '../../features/winner/presentation/bloc/winner_bloc/winner_bloc.dart';
import '../../features/winner/presentation/bloc/won_auctions_bloc/won_auctions_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final googleSignIn = GoogleSignIn(
    serverClientId: OAuthConfig.googleServerClientId,
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<LocalUserStorage>(() => LocalUserStorage(sl()));
  sl.registerLazySingleton(
    () => FcmTokenService(messaging: sl(), firestore: sl(), auth: sl()),
  );
  sl.registerLazySingleton(() => LocalNotificationService());
  sl.registerLazySingleton(
    () => NotificationManager(localNotificationService: sl()),
  );

  _initAuth();
  _initProfile();
  _initNotifications();
  _initAuctions();
  _initAuctionDetail();
  _initBids();
  _initWinner();

  await sl<NotificationManager>().initialize();
}

void _initAuth() {
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      googleSignInUseCase: sl(),
      logoutUseCase: sl(),
      fcmTokenService: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => WatchAuthStateUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localUserStorage: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );
}

void _initProfile() {
  sl.registerFactory(
    () => ProfileBloc(
      getCachedProfileUseCase: sl(),
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCachedProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => HasPhoneNumberUseCase(sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), localUserStorage: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(auth: sl(), firestore: sl()),
  );
}

void _initAuctions() {
  sl.registerFactory(
    () =>
        PostAuctionBloc(postAuctionUseCase: sl(), hasPhoneNumberUseCase: sl()),
  );

  sl.registerFactory(
    () => HomeBloc(
      watchLiveAuctionsUseCase: sl(),
      watchUnreadNotificationsCountUseCase: sl(),
    ),
  );

  sl.registerFactory(() => MyAuctionsBloc(watchMyAuctionsUseCase: sl()));
  sl.registerLazySingleton(() => PostAuctionUseCase(sl()));
  sl.registerLazySingleton(() => WatchLiveAuctionsUseCase(sl()));
  sl.registerLazySingleton(() => WatchMyAuctionsUseCase(sl()));

  sl.registerLazySingleton<AuctionRepository>(
    () => AuctionRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuctionRemoteDataSource>(
    () =>
        AuctionRemoteDataSourceImpl(firestore: sl(), storage: sl(), auth: sl()),
  );
}

void _initAuctionDetail() {
  sl.registerFactoryParam<AuctionDetailBloc, String, void>(
    (auctionId, _) => AuctionDetailBloc(
      auctionId: auctionId,
      currentUserId: sl<FirebaseAuth>().currentUser?.uid,
      watchAuctionUseCase: sl(),
      watchBidsUseCase: sl(),
      placeBidUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => WatchAuctionUseCase(sl()));
  sl.registerLazySingleton(() => WatchBidsUseCase(sl()));
  sl.registerLazySingleton(() => PlaceBidUseCase(sl()));

  sl.registerLazySingleton<BidRepository>(
    () => BidRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<BidRemoteDataSource>(
    () => BidRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
}

void _initBids() {
  sl.registerFactory(() => MyBidsBloc(watchMyBidsUseCase: sl(), auth: sl()));
  sl.registerLazySingleton(() => WatchMyBidsUseCase(sl()));
  sl.registerLazySingleton<MyBidsRepository>(
    () => MyBidsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MyBidsRemoteDataSource>(
    () => MyBidsRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
}

void _initNotifications() {
  sl.registerFactory(
    () => NotificationsBloc(
      watchNotificationsUseCase: sl(),
      markNotificationAsReadUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => WatchNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsReadUseCase(sl()));
  sl.registerLazySingleton(() => WatchUnreadNotificationsCountUseCase(sl()));

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
}

void _initWinner() {
  sl.registerFactory(() => WonAuctionsBloc(watchWonAuctionsUseCase: sl()));
  sl.registerFactory(() => WinnerBloc(getWinnerDetailUseCase: sl()));

  sl.registerLazySingleton(() => WatchWonAuctionsUseCase(sl()));
  sl.registerLazySingleton(() => GetWinnerDetailUseCase(sl()));

  sl.registerLazySingleton<WinnerRepository>(
    () => WinnerRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<WinnerRemoteDataSource>(
    () => WinnerRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
}
