import express from "express";
import Authentication from "../controller/authentication.controller.js";

const router = express.Router();

router.get("/", (req, res) => {
  return res.send({
    data: "Flutter redis Authentication",
  });
});

router.post("/signup", Authentication.signUp);
router.post("/login", Authentication.login);

export default router;
