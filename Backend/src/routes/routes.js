import express from "express";
import { getDates } from "../controller/habitController.js";
import { postDataToDynamoDB } from "../controller/tableController.js";
const router = express.Router();

router.get("/getDates", getDates);
router.post("/postData", postDataToDynamoDB); 

export default router;
