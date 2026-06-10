class FirestorePaths {
  FirestorePaths._();

  static const String users = 'users';
  static const String auctions = 'auctions';
  static const String bids = 'bids';
  static const String myBids = 'myBids';
  static const String notifications = 'notifications';
}

class UserFields {
  UserFields._();

  static const String name = 'name';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String fcmToken = 'fcmToken';
  static const String wonCount = 'wonCount';
  static const String soldCount = 'soldCount';
  static const String bidsCount = 'bidsCount';
  static const String createdAt = 'createdAt';
}

class AuctionFields {
  AuctionFields._();

  static const String title = 'title';
  static const String category = 'category';
  static const String images = 'images';
  static const String sellerId = 'sellerId';
  static const String currencyCode = 'currencyCode';
  static const String startingPrice = 'startingPrice';
  static const String currentBid = 'currentBid';
  static const String currentBidderId = 'currentBidderId';
  static const String bidIncrement = 'bidIncrement';
  static const String totalBids = 'totalBids';
  static const String endTime = 'endTime';
  static const String status = 'status';
  static const String winnerId = 'winnerId';
  static const String createdAt = 'createdAt';
}

class BidFields {
  BidFields._();

  static const String bidderId = 'bidderId';
  static const String bidderName = 'bidderName';
  static const String amount = 'amount';
  static const String timestamp = 'timestamp';
}

class MyBidFields {
  MyBidFields._();

  static const String auctionId = 'auctionId';
  static const String title = 'title';
  static const String imageUrl = 'imageUrl';
  static const String currencyCode = 'currencyCode';
  static const String currentBid = 'currentBid';
  static const String myHighestBid = 'myHighestBid';
  static const String isWinning = 'isWinning';
  static const String status = 'status';
  static const String updatedAt = 'updatedAt';
}

class NotificationFields {
  NotificationFields._();

  static const String title = 'title';
  static const String body = 'body';
  static const String auctionId = 'auctionId';
  static const String type = 'type';
  static const String isRead = 'isRead';
  static const String createdAt = 'createdAt';
}
