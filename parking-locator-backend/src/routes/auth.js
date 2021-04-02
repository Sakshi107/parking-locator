const express = require("express");
const User = require("../database/models/user");
const { generateJWTToken } = require("../services/jwtService");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("auth service");
});

router.post("/signup", async (req, res) => {
  try {
    const user = await User.create({ ...req.body });
    const { password, ...profile } = user.toJSON();
    const token = `bearer ` + generateJWTToken(profile);
    res.json({ status: "SUCCESS", authToken: token, profile });
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (user) {
      if (user.password === password) {
        const { password, ...profile } = user.toJSON();
        const token = `bearer ` + generateJWTToken(profile);
        res.json({ status: "SUCCESS", token, profile });
      } else {
        res.status(401).json({ status: "UNAUTHORIZED", message: "wrong password" });
      }
    } else {
      res.status(401).json({ status: "UNAUTHORIZED", message: "User does not exist" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});
module.exports = router;
