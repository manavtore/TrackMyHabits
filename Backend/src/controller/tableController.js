import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { formatISO } from "date-fns";
import { db } from "../config/firebaseConfig.js";
import { CurrentDate } from "../model/currentDate.js";
import { FirebaseAuth } from "../config/firebaseConfig.js";
import { Habit } from "../model/habit.js";

const client = new DynamoDBClient({ region: "your-region" });

export const postDataToDynamoDB = async () => {
  try {
    const userId = FirebaseAuth.instance.currentUser.userId;
    const currentDatesSnapshot = await db
      .collection("CurrentDates")
      .where("userid", "==", userId)
      .get();
    const habitDatesSnapshot = await db
      .collection("habits")
      .where("userid", "==", userId)
      .get();

    const currentDates = currentDatesSnapshot.docs.map((doc) =>
      CurrentDate.fromMap(doc.data())
    );
    const habits = habitDatesSnapshot.docs.map((doc) =>
      Habit.fromMap(doc.data())
    );

    for (const currentDate of currentDates) {
      const params = {
        TableName: "Dates",
        Item: {
          userid: { S: currentDate.userid },
          date: { S: currentDate.date },
          habitsOfTheDay: {
            L: currentDate.habitsOfTheDay.map((habit) => ({
              M: habit.toMap(),
            })),
          },
          score: { N: currentDate.score.toString() },
        },
      };
      await client.send(new PutItemCommand(params));
      console.log(
        `Inserted currentDate for user '${currentDate.userid}' on date '${currentDate.date}' into DynamoDB.`
      );
    }

    for (const habit of habits) {
      await habit.save();
      console.log(
        `Inserted habit '${habit.id}' for user '${habit.userid}' into DynamoDB.`
      );
    }
  } catch (error) {
    console.error("Error posting data to DynamoDB:", error);
  }
};
