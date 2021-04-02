const express = require("express");
const ParkingLocations = require("../database/models/parkingLocations");
const ParkingHistory = require("../database/models/ParkingHistory");
const moment = require("moment");
const router = express.Router();

router.get("/", async (req, res) => {
  res.send("booking service");
});

router.post("/checkin", async (req, res) => {
  console.log(req.body);
  const { userID } = req.user;
  const { spotID, isEmpty } = req.body;

  const imageIfFull = "http://www.theshadestudio.co.in/wp-content/uploads/photo-gallery/thumb/DSC03643.jpg";
  try {
    const parkingSpot = await ParkingLocations.findOne({ slotID: spotID });
    if (parkingSpot) {
      if (parkingSpot.isEmpty) {
        if (isEmpty === "false") {
          const parkingHistory = await ParkingHistory.create({ userID, slotID: spotID });
          res.json({ STATUS: "SUCCESS", carImage: imageIfFull, bookingID: parkingHistory._id });
        } else {
          res.json({ status: "FAILED", message: "NO car is present in the slot" });
        }
      } else {
        res.json({ STATUS: "FAILED", message: "Slot is not empty" });
      }
    } else {
      res.json({ STATUS: "FAILED", message: "Slot not found" });
    }
    if (isEmpty) {
    }
  } catch (error) {
    throw error;
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.post("/checkin/verify", async (req, res) => {
  const { userID } = req.user;
  const { spotID, bookingID } = req.body;
  try {
    const booking = await ParkingHistory.findOne({ slotID: spotID, userID, _id: bookingID });
    if (booking) {
      booking.isConfirmed = true;
      booking.startTime = new Date();
      await booking.save();
      await ParkingLocations.findOneAndUpdate({ spotID }, { $set: { isEmpty: false } });
      res.json({ status: "SUCCESS", bookingDetails: booking });
    } else {
      res.json({ status: "FAILED", message: "invali details" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.post("/checkout", async (req, res) => {
  const { userID } = req.user;
  const { spotID } = req.body;
  try {
    const booking = await ParkingHistory.findOne({
      userID,
      slotID: spotID,
      isConfirmed: true,
      endTime: { $exists: false },
      duration: { $exists: false },
    });

    if (booking) {
      booking.endTime = new Date();
      booking.duration = Math.max(1, moment().diff(booking.startTime, "hours"));
      await booking.save();
      await ParkingLocations.findOneAndUpdate({ spotID }, { $set: { isEmpty: true } });
      res.json({ status: "SUCCESS", message: "checked Out", billedPeriod: booking.duration });
    } else {
      res.json({ status: "FAILED", message: "no such booking" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

module.exports = router;
