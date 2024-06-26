const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNewMessageNotification = functions.firestore
  .document("messages/{messageId}")
  .onCreate((snap, context) => {
    const newValue = snap.data();
    const payload = {
      notification: {
        title: "New Message",
        body: `${newValue.sender} sent you a message`,
      },
    };

    return admin.messaging().sendToTopic("messages", payload);
  });
