const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteUserByEmail = functions.https.onCall(async (data, context) => {
  const email = data.email;

  if (!email) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Email is required."
    );
  }

  try {
    // cari user di Authentication berdasarkan email
    const userRecord = await admin.auth().getUserByEmail(email);

    // hapus user dari Authentication
    await admin.auth().deleteUser(userRecord.uid);

    // hapus data dari Firestore (opsional)
    const snapshot = await admin.firestore()
      .collection("Students")
      .where("email", "==", email)
      .get();

    for (const doc of snapshot.docs) {
      await doc.ref.delete();
    }

    return { result: `User with email ${email} deleted successfully.` };
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});
