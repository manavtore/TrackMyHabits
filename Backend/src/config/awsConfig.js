import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import * as dotenv from "dotenv";

dotenv.config();

const ACCESS_KEY = process.env.ACCESS_KEY;
const SECRET_ACCESS_KEY = process.env.SECRET_ACCESS_KEY;

const client = new DynamoDBClient({
  region: "ap-south-1",
  credentials: {
    accessKeyId: ACCESS_KEY,
    secretAccessKey: SECRET_ACCESS_KEY,
  },
});

export default client;
