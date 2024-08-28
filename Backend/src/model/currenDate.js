import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { formatISO, parseISO } from "date-fns";

const client = new DynamoDBClient({ region: "ap-south-1" });

class SubHabit {
  constructor({ id, title, isComplete }) {
    this.id = id;
    this.title = title;
    this.isComplete = isComplete;
  }

  toMap() {
    return {
      id: { S: this.id },
      title: { S: this.title },
      isComplete: { BOOL: this.isComplete },
    };
  }

  static fromMap(map) {
    return new SubHabit({
      id: map.id.S,
      title: map.title.S,
      isComplete: map.isComplete.BOOL,
    });
  }
}

class CurrentDate {
  constructor({ habitsOfTheDay, score = 0, date, userid }) {
    this.habitsOfTheDay = habitsOfTheDay; 
    this.score = score;
    this.date = date;
    this.userid = userid;
  }

  calculateScore() {
    this.score = this.habitsOfTheDay.filter((habit) => habit.isComplete).length;
  }

  toMap() {
    return {
      habitsOfTheDay: {
        L: this.habitsOfTheDay.map((habit) => ({ M: habit.toMap() })),
      },
      score: { N: this.score.toString() },
      date: { S: this.date },
      userid: { S: this.userid },
    };
  }

  static fromMap(map) {
    return new CurrentDate({
      habitsOfTheDay: map.habitsOfTheDay.L.map((item) =>
        SubHabit.fromMap(item.M)
      ),
      score: parseInt(map.score.N, 10),
      date: map.date.S,
      userid: map.userid.S,
    });
  }

  async save() {
    const params = {
      TableName: "Dates",
      Item: this.toMap(),
    };
    await client.send(new PutItemCommand(params));
  }
}

export { CurrentDate, SubHabit };
