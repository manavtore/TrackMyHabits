// import { db } from "../config/firebaseConfig.js"
// const CurrentDates = db.collection("CurrentDates");
// const HabitDates = db.collection("Habits");

// export const getDates = async (req, res) => {
//   const userId = req.query.userid;

//   try {
//     const currentDatesSnapshot = await CurrentDates.where(
//       "userid",
//       "==",
//       userId
//     ).get();
//     const habitDatesSnapshot = await HabitDates.where(
//       "userid",
//       "==",
//       userId
//     ).get();

//     const currentDates = currentDatesSnapshot.docs.map((doc) => doc.data());
//     const habitDates = habitDatesSnapshot.docs.map((doc) => doc.data());

//     res.json({ currentDates, habitDates });
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// };

// export default getDates;