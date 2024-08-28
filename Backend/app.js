import express from "express";
import cors from "cors";
import admin from "firebase-admin";
import serviceAccount from "./habittracker-e6465-firebase-adminsdk-93kzb-035b099f96.json" assert { type: "json" };
import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import * as dotenv from "dotenv";

dotenv.config();

const { ACCESS_KEY, SECRET_ACCESS_KEY } = process.env;

const client = new DynamoDBClient({
  region: "ap-south-1",
  credentials: {
    accessKeyId: ACCESS_KEY,
    secretAccessKey: SECRET_ACCESS_KEY,
  },
});

const HABITS_TABLE_NAME = "Habits";
const DATES_TABLE_NAME = "Dates";

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const CurrentDates = db.collection("CurrentDates");
const HabitDates = db.collection("Habits");

const app = express();
app.use(cors());
app.use(express.json());

async function fetchAndSaveData(userId) {
  try {
    const [currentDatesSnapshot, habitDatesSnapshot] = await Promise.all([
      CurrentDates.where("userid", "==", userId).get(),
      HabitDates.where("userid", "==", userId).get(),
    ]);

    const currentDates = currentDatesSnapshot.docs.map((doc) => doc.data());
    const habitDates = habitDatesSnapshot.docs.map((doc) => doc.data());
    
    var i = 0;
    for (const date of currentDates) {
        i++;
        if(i==100) break;
      const item = {
        TableName: DATES_TABLE_NAME,
        Item: {
          userid: { S: userId },
          date: { S: date.date },
          score: { N: date.score.toString() },
          habitsOfTheDay: {
            L: date.habitsOfTheDay.map((habit) => ({
              M: {
                title: { S: habit.title },
                isComplete: { BOOL: habit.isComplete },
              },
            })),
          },
        },
      };
      try {
        await client.send(new PutItemCommand(item));
      } catch (error) {
        console.error("Error saving current date item:", error);
      }
    }

    for (const habit of habitDates) {
      const item = {
        TableName: HABITS_TABLE_NAME,
        Item: {
          userid: { S: userId },
          id: { S: habit.id },
          title: { S: habit.title },
          description: { S: habit.description },
          startDate: { S: habit.startDate.toDate().toISOString() },
          endDate: { S: habit.endDate.toDate().toISOString() },
          streak: { N: habit.streak.toString() },
          isComplete: { BOOL: habit.isComplete },
          totalCompletions: { N: habit.totalCompletions.toString() },
          reminderTime: {
            M: {
              hour: { N: habit.reminderTime.hour.toString() },
              minute: { N: habit.reminderTime.minute.toString() },
            },
          },
          days: {
            L: habit.days.map((day) => ({
              M: {
                date: { S: day.date.toISOString() },
                completed: { BOOL: day.completed },
              },
            })),
          },
          selectedWeekdays: {
            L: habit.selectedWeekdays.map((day) => ({ S: day })),
          },
        },
      };
      try {
        const result = await client.send(new PutItemCommand(item));
        console.log("Result: ", result);
      } catch (error) {
        console.error("Error saving habit item:", error);
      }
    }
  } catch (error) {
    console.error("Error fetching or storing data:", error);
  }
}

app.get("/fetchAndSaveData", async (req, res) => {
  const { userId } = req.query;
  if (!userId) {
    return res.status(400).send("userId is required");
  }
  await fetchAndSaveData(userId);
  res.send("Data fetching and saving completed");
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
