import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { formatISO, parseISO } from "date-fns";

const client = new DynamoDBClient({ region: "ap-south-1" });

class Habit {
  constructor({
    title,
    description,
    startDate,
    endDate,
    streak,
    isComplete,
    totalCompletions,
    reminderTime,
    days,
    selectedWeekdays,
    userid,
    id,
  }) {
    this.title = title;
    this.description = description;
    this.startDate = startDate;
    this.endDate = endDate;
    this.streak = streak;
    this.isComplete = isComplete;
    this.totalCompletions = totalCompletions;
    this.reminderTime = reminderTime; 
    this.days = days; 
    this.userid = userid;
    this.id = id;
  }

  toMap() {
    return {
      title: { S: this.title },
      description: { S: this.description },
      startDate: { S: formatISO(this.startDate) },
      endDate: { S: formatISO(this.endDate) },
      streak: { N: this.streak.toString() },
      isComplete: { BOOL: this.isComplete },
      totalCompletions: { N: this.totalCompletions.toString() },
      reminderTime: {
        M: {
          hour: { N: this.reminderTime.hour.toString() },
          minute: { N: this.reminderTime.minute.toString() },
        },
      },
      days: {
        L: this.days.map((day) => ({
          M: {
            date: { S: formatISO(day.date) },
            isComplete: { BOOL: day.isComplete },
          },
        })),
      },
      selectedWeekdays: { L: this.selectedWeekdays.map((day) => ({ S: day })) },
      userid: { S: this.userid },
      id: { S: this.id },
    };
  }

  static fromMap(map) {
    return new Habit({
      title: map.title.S,
      description: map.description.S,
      startDate: parseISO(map.startDate.S),
      endDate: parseISO(map.endDate.S),
      streak: parseInt(map.streak.N, 10),
      isComplete: map.isComplete.BOOL,
      totalCompletions: parseInt(map.totalCompletions.N, 10),
      reminderTime: {
        hour: parseInt(map.reminderTime.M.hour.N, 10),
        minute: parseInt(map.reminderTime.M.minute.N, 10),
      },
      days: map.days.L.map((day) => ({
        date: parseISO(day.M.date.S),
        isComplete: day.M.isComplete.BOOL,
      })),
      selectedWeekdays: map.selectedWeekdays.L.map((day) => day.S),
      userid: map.userid.S,
      id: map.id.S,
    });
  }

  async save() {
    const params = {
      TableName: "Habits",
      Item: this.toMap(),
    };
    await client.send(new PutItemCommand(params));
  }
}

export default Habit;