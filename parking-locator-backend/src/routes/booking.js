const express = require("express");
const ParkingLocations = require("../database/models/parkingLocations");
const ParkingHistory = require("../database/models/ParkingHistory");
const moment = require("moment");
const getDistanceFromLatLonInKm = require("../helpers/mapDistance");
const router = express.Router();
const {TIME_FORMAT}=require('../config');

router.get("/", async (req, res) => {
  res.send("booking service");
});

router.post("/checkin", async (req, res) => {
  console.log(req.body);
  console.log(req.user);
  const { userID } = req.user;
  const { spotID, lat, long,isEmpty } = req.body;

  const imageIfFull = "https://martolex-book-images.s3.ap-south-1.amazonaws.com/car-1.jpeg";
  try {
    console.log("lets tryy");
    const parkingSpot = await ParkingLocations.findOne({ slotID: spotID });
    if (parkingSpot) {
      console.log(parkingSpot);
      if (parkingSpot.isEmpty) {
        const parkingLocation = parkingSpot.Location.coordinates;
        const distance = getDistanceFromLatLonInKm(parkingLocation[0], parkingLocation[1], lat, long);
        if (distance < 100) {
          if (isEmpty === "false") {
            const parkingHistory = await ParkingHistory.create({ userID, slotID: spotID });
            res.json({ STATUS: "SUCCESS", carImage: imageIfFull, bookingID: parkingHistory._id });
          } else {
            res.json({ status: "FAILED", message: "NO car is present in the slot" });
          }
        } else {
          res.json({ status: "FAILED", message: "You are too far away from the parking" });
        }
      } else {
        res.json({ status: "FAILED", message: "Slot is not empty" });
      }
    } else {
      res.json({ status: "FAILED", message: "Slot not found" });
    }
   
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.post("/bookPrior", async (req, res) => {
  try {
    const { spotID, startTime, duration } = req.body;
    console.log(startTime);
    const { userID } = req.user;
    const parkingSpot = await ParkingLocations.findOne({ slotID: spotID });
    if (parkingSpot) {
      const startTimeObj = moment(startTime,TIME_FORMAT);
      const endTime = startTimeObj.clone().add(duration, "hours");
      const startTimeMinutesSinceDayStart = startTimeObj.diff(startTimeObj.clone().startOf("day"), "minutes");
      console.log(parkingSpot.activeHours.start, startTimeMinutesSinceDayStart,);
      if (
        parkingSpot.activeHours.start <= startTimeMinutesSinceDayStart &&
        parkingSpot.activeHours.end > startTimeMinutesSinceDayStart + 60 * duration
      ) {
        const booking = await ParkingHistory.create({
          userID,
          slotID: spotID,
          advancedBooking: true,
          estimatedStartTime: startTimeObj.toDate(),
          estimatedEndTime: endTime.toDate(),
          isConfirmed: true,
        });
        res.json({ status: "SUCCESS", bookingDetails: booking });
      } else {
        res.json({ status: "FAILED", message: "cannot book for this time duration." });
      }
    } else {
      res.json({ status: "FAILED", message: "Slot not found" });
    }
  } catch (err) {
    res.status(500).send({ message: err.message, errorType: err.name });
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
