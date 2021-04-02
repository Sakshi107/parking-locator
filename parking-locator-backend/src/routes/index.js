const express = require("express");
const router = express.Router();
const authRouter = require("./auth");
const parkingRouter = require("./parking");
const userRouter = require("./user");
const bookingRouter = require("./booking");
const { isLoggedIn } = require("../middleware/authMiddleware");

router.use("/auth", authRouter);
router.use("/user", isLoggedIn, userRouter);
router.use("/parking", isLoggedIn, parkingRouter);
router.use("/booking", isLoggedIn, bookingRouter);

module.exports = router;
