import admin from "firebase-admin";
import serviceAccount from "../habittracker-e6465-firebase-adminsdk-93kzb-035b099f96.json" assert { type: "json" };

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
export { db };

