import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

type NotifyParams = {
  userId: string;
  title: string;
  body: string;
  auctionId: string;
  type: string;
  notificationId?: string;
};

/**
 * Builds a safe deterministic notification id.
 * Useful for important events where duplicate notifications should be avoided.
 */
function buildNotificationId(type: string, auctionId: string): string {
  return `${type}_${auctionId}`;
}

/**
 * Sends an in-app notification and optional FCM push to a user.
 * If notificationId is provided, duplicate notification docs are avoided.
 */
async function notify(params: NotifyParams): Promise<void> {
  const userRef = db.collection("users").doc(params.userId);
  const userSnap = await userRef.get();

  if (!userSnap.exists) {
    logger.warn("Notification skipped. User not found.", {
      userId: params.userId,
      auctionId: params.auctionId,
      type: params.type,
    });
    return;
  }

  const userData = userSnap.data() ?? {};
  const fcmToken = userData.fcmToken as string | undefined;

  const notificationRef = params.notificationId ?
    userRef.collection("notifications").doc(params.notificationId) :
    userRef.collection("notifications").doc();

  await notificationRef.set(
    {
      title: params.title,
      body: params.body,
      auctionId: params.auctionId,
      type: params.type,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    {merge: false},
  );

  if (!fcmToken) {
    logger.info("In-app notification created. No FCM token.", {
      userId: params.userId,
      auctionId: params.auctionId,
      type: params.type,
    });
    return;
  }

  try {
    await messaging.send({
      token: fcmToken,
      notification: {
        title: params.title,
        body: params.body,
      },
      data: {
        auctionId: params.auctionId,
        type: params.type,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "bidwave_high_importance_channel",
          priority: "max",
          defaultSound: true,
          defaultVibrateTimings: true,
          visibility: "public",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    });
  } catch (error: unknown) {
    logger.error("Failed to send FCM notification.", {
      userId: params.userId,
      auctionId: params.auctionId,
      type: params.type,
      error,
    });

    const errorCode = (error as { code?: string }).code;

    if (
      errorCode === "messaging/registration-token-not-registered" ||
      errorCode === "messaging/invalid-registration-token"
    ) {
      await userRef.update({
        fcmToken: admin.firestore.FieldValue.delete(),
      });

      logger.info("Invalid FCM token removed.", {
        userId: params.userId,
      });
    }
  }
}

/**
 * Updates all bidders' myBids docs when an auction ends.
 */
async function syncBiddersAfterAuctionEnded(
  auctionId: string,
  winnerId: string | null,
  currentBid: number,
): Promise<void> {
  const bidsSnapshot = await db
    .collection("auctions")
    .doc(auctionId)
    .collection("bids")
    .get();

  const bidderIds = new Set<string>();

  bidsSnapshot.docs.forEach((doc) => {
    const bidderId = doc.data().bidderId as string | undefined;

    if (bidderId) {
      bidderIds.add(bidderId);
    }
  });

  if (bidderIds.size === 0) return;

  let batch = db.batch();
  let operationCount = 0;

  for (const bidderId of bidderIds) {
    const myBidRef = db
      .collection("users")
      .doc(bidderId)
      .collection("myBids")
      .doc(auctionId);

    batch.set(
      myBidRef,
      {
        status: "ended",
        currentBid,
        isWinning: bidderId === winnerId,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true},
    );

    operationCount++;

    if (operationCount === 450) {
      await batch.commit();
      batch = db.batch();
      operationCount = 0;
    }
  }

  if (operationCount > 0) {
    await batch.commit();
  }
}

/**
 * Syncs myBids and sends notifications when a new bid is created.
 */
export const onBidCreated = onDocumentCreated(
  {
    document: "auctions/{auctionId}/bids/{bidId}",
    region: "us-central1",
  },
  async (event) => {
    const auctionId = event.params.auctionId;
    const bidSnapshot = event.data;

    if (!bidSnapshot) {
      logger.warn("No bid snapshot found.", {auctionId});
      return;
    }

    const bidData = bidSnapshot.data();

    const bidderId = bidData.bidderId as string | undefined;
    const amount = Number(bidData.amount ?? 0);
    const bidderName = bidData.bidderName as string | undefined;

    if (!bidderId || amount <= 0) {
      logger.warn("Invalid bid data.", {auctionId, bidData});
      return;
    }

    const auctionRef = db.collection("auctions").doc(auctionId);
    const auctionSnapshot = await auctionRef.get();

    if (!auctionSnapshot.exists) {
      logger.warn("Auction not found.", {auctionId});
      return;
    }

    const auctionData = auctionSnapshot.data() ?? {};

    const currentBidderId = auctionData.currentBidderId as string | undefined;
    const currentBid = Number(auctionData.currentBid ?? 0);
    const sellerId = auctionData.sellerId as string | undefined;
    const title = String(auctionData.title ?? "Auction");
    const currencyCode = String(auctionData.currencyCode ?? "PKR");

    if (currentBidderId !== bidderId || currentBid !== amount) {
      logger.info("Bid is not current highest bid, skipping.", {
        auctionId,
        bidderId,
        amount,
        currentBidderId,
        currentBid,
      });
      return;
    }

    const previousBidQuery = await auctionRef
      .collection("bids")
      .orderBy("timestamp", "desc")
      .limit(2)
      .get();

    const previousBidDoc = previousBidQuery.docs.find((doc) => {
      const data = doc.data();
      return data.bidderId && data.bidderId !== bidderId;
    });

    const batch = db.batch();

    const currentUserMyBidRef = db
      .collection("users")
      .doc(bidderId)
      .collection("myBids")
      .doc(auctionId);

    batch.set(
      currentUserMyBidRef,
      {
        auctionId,
        title,
        imageUrl:
          Array.isArray(auctionData.images) && auctionData.images.length > 0 ?
            auctionData.images[0] :
            "",
        currencyCode,
        currentBid,
        myHighestBid: amount,
        isWinning: true,
        status: auctionData.status ?? "live",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true},
    );

    let previousBidderId: string | null = null;

    if (previousBidDoc) {
      previousBidderId = previousBidDoc.data().bidderId as string;

      const previousUserMyBidRef = db
        .collection("users")
        .doc(previousBidderId)
        .collection("myBids")
        .doc(auctionId);

      batch.set(
        previousUserMyBidRef,
        {
          auctionId,
          currentBid,
          isWinning: false,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        {merge: true},
      );
    }

    await batch.commit();

    const amountText = `${currencyCode} ${amount}`;
    const notificationTasks: Array<Promise<void>> = [];

    if (sellerId && sellerId !== bidderId) {
      notificationTasks.push(
        notify({
          userId: sellerId,
          title: "New bid on your auction",
          body: `${bidderName ?? "Someone"} bid ${amountText} on ${title}.`,
          auctionId,
          type: "new_bid",
        }),
      );
    }

    if (previousBidderId && previousBidderId !== bidderId) {
      notificationTasks.push(
        notify({
          userId: previousBidderId,
          title: "You were outbid",
          body: `Someone placed a higher bid of ${amountText} on ${title}.`,
          auctionId,
          type: "outbid",
        }),
      );
    }

    await Promise.allSettled(notificationTasks);

    logger.info("Bid sync and notifications completed.", {
      auctionId,
      bidderId,
      amount,
      previousBidderId,
      sellerId,
    });
  },
);

/**
 * Closes expired live auctions and sends winner/seller notifications.
 */
export const closeExpiredAuctions = onSchedule(
  {
    schedule: "every 1 minutes",
    region: "us-central1",
  },
  async () => {
    const now = admin.firestore.Timestamp.now();

    const expiredAuctionsSnapshot = await db
      .collection("auctions")
      .where("status", "==", "live")
      .where("endTime", "<=", now)
      .limit(50)
      .get();

    if (expiredAuctionsSnapshot.empty) {
      logger.info("No expired auctions found.");
      return;
    }

    const tasks = expiredAuctionsSnapshot.docs.map(async (auctionDoc) => {
      const auctionId = auctionDoc.id;
      const auctionRef = auctionDoc.ref;

      let wasClosed = false;
      let sellerId: string | null = null;
      let winnerId: string | null = null;
      let title = "Auction";
      let currentBid = 0;
      let currencyCode = "PKR";

      await db.runTransaction(async (transaction) => {
        const freshAuctionSnap = await transaction.get(auctionRef);

        if (!freshAuctionSnap.exists) return;

        const auctionData = freshAuctionSnap.data() ?? {};
        const status = auctionData.status as string | undefined;
        const endTime = auctionData.endTime as
          | admin.firestore.Timestamp
          | undefined;

        if (status !== "live") return;
        if (!endTime || endTime.toMillis() > Date.now()) return;

        sellerId = auctionData.sellerId as string | null;
        winnerId = auctionData.currentBidderId as string | null;
        title = String(auctionData.title ?? "Auction");
        currentBid = Number(auctionData.currentBid ?? 0);
        currencyCode = String(auctionData.currencyCode ?? "PKR");

        transaction.update(auctionRef, {
          status: "ended",
          winnerId: winnerId ?? null,
        });

        if (winnerId) {
          const winnerRef = db.collection("users").doc(winnerId);

          transaction.set(
            winnerRef,
            {
              wonCount: admin.firestore.FieldValue.increment(1),
            },
            {merge: true},
          );

          if (sellerId) {
            const sellerRef = db.collection("users").doc(sellerId);

            transaction.set(
              sellerRef,
              {
                soldCount: admin.firestore.FieldValue.increment(1),
              },
              {merge: true},
            );
          }

          const winnerMyBidRef = winnerRef.collection("myBids").doc(auctionId);

          transaction.set(
            winnerMyBidRef,
            {
              status: "ended",
              isWinning: true,
              currentBid,
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            },
            {merge: true},
          );
        }

        wasClosed = true;
      });

      if (!wasClosed) return;

      await syncBiddersAfterAuctionEnded(auctionId, winnerId, currentBid);

      const amountText = `${currencyCode} ${currentBid}`;

      logger.info("Preparing auction ended notifications.", {
        auctionId,
        winnerId,
        sellerId,
        title,
        currentBid,
      });

      const notificationTasks: Array<Promise<void>> = [];

      if (winnerId) {
        notificationTasks.push(
          notify({
            userId: winnerId,
            title: "You won!",
            body: `You won ${title} for ${amountText}.`,
            auctionId,
            type: "auction_won",
            notificationId: buildNotificationId("auction_won", auctionId),
          }),
        );
      }

      if (sellerId) {
        notificationTasks.push(
          notify({
            userId: sellerId,
            title: "Auction ended",
            body: winnerId ?
              `${title} ended with a winning bid of ${amountText}.` :
              `${title} ended with no bids.`,
            auctionId,
            type: "auction_ended",
            notificationId: buildNotificationId("auction_ended", auctionId),
          }),
        );
      }

      await Promise.allSettled(notificationTasks);

      logger.info("Auction closed successfully.", {
        auctionId,
        winnerId,
        sellerId,
      });
    });

    await Promise.allSettled(tasks);
  },
);
