const express = require("express");
const ParkingHistory = require("../database/models/ParkingHistory");
const ParkingLocations = require("../database/models/parkingLocations");
const moment = require("moment");
const { TIME_FORMAT } = require("../config");

const router = express.Router();

router.get("/", (req, res) => {
  res.send("user service");
});

router.post("/myParking", async (req, res) => {
  try {
    const { lat, long, startTime, endTime, address, parkingType, chargesPerHour } = req.body;
    const { userID } = req.user;
    const startTimeObj = moment(startTime, TIME_FORMAT);
    
    const endTimeObj = moment(endTime, TIME_FORMAT);
    console.log(endTime);
    const startOfDay = moment().startOf("day");
    console.log(address);
    const parking = await ParkingLocations.create({
      userID,
      Location: { type: "Point", coordinates: [lat, long] },
      activeHours: {
        start: startTimeObj.diff(startOfDay, "minutes"),
        end: endTimeObj.diff(startOfDay, "minutes"),
      },
      address,
      parkingType,
      chargesPerHour,
    });
    
    res.json({ status: "SUCCESS", parking });
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.post("/myParking/:spotID/setActiveHours", async (req, res) => {
  const { userID } = req.user;
  const { spotID } = req.params;
  const { startTime, endTime } = req.body;
  console.log(spotID, userID);
  try {
    const parking = await ParkingLocations.findOne({ slotID: spotID, userID });
    if (parking) {
      const startTimeObj = moment(startTime, TIME_FORMAT);
      const endTimeObj = moment(endTime, TIME_FORMAT);
      if (startTimeObj.isAfter(endTimeObj)) {
        res.json({ status: "FAILED", message: "invalid start and end times" });
        return;
      }
      const isCurrentTimeSlot = moment().isBetween(startTimeObj, endTimeObj);
      if (parking.isEmpty || !isCurrentTimeSlot) {
        const startOfDay = moment().startOf("day");
        parking.activeHours = {
          start: startTimeObj.diff(startOfDay, "minutes"),
          end: endTimeObj.diff(startOfDay, "minutes"),
        };
        await parking.save();
        res.json({ status: "SUCCESS", parking });
      } else {
        res.json({ status: "FAILED", message: "Cannot modify at the moment" });
      }
    } else {
      res.json({ status: "FAILED", message: "parking not found" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.get("/myParking", async (req, res) => {
  try {
    const { userID } = req.user;
    const parkings = await ParkingLocations.find({ userID });
    const parkingsRes = parkings.map((parking) => {
      const startTime = moment().startOf("day").add(parking.activeHours.start, "minutes").format(TIME_FORMAT);
      const endTime = moment().startOf("day").add(parking.activeHours.end, "minutes").format(TIME_FORMAT);
      const parkingJSON = parking.toJSON();
      return { ...parkingJSON, activeHours: { start: startTime, end: endTime } };
    });
    res.json({ status: "SUCCESS", parkings: parkingsRes });
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.get("/myParking/bookings", async (req, res) => {
  try {
    const { spotID } = req.query;
    const bookings = await ParkingHistory.aggregate([
      { $match: { slotID: spotID, isConfirmed: true } },
      { $lookup: { from: "users", localField: "userID", foreignField: "userID", as: "user" } },
      { $unwind: { path: "$user" } },
      { $project: { "user.password": 0, "user.mobile": 0, "user.walletBalance": 0 } },
    ]);
    if (bookings) {
      res.json({ status: "SUCCESS", bookings });
    } else {
      res.json({ status: "NOTFOUND", message: "Could not find the requested slot" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.get("/myParking/:spotID", async (req, res) => {
  try {
    const { spotID } = req.params;
    const { userID } = req.user;
    let parking = await ParkingLocations.findOne({ slotID: spotID, userID });
    if (parking) {
      parking = parking.toJSON();

      parking.activeHours.start = moment().startOf("day").add(parking.activeHours.start, "minutes").format(TIME_FORMAT);
      parking.activeHours.end = moment().startOf("day").add(parking.activeHours.end, "minutes").format(TIME_FORMAT);
      res.json({ status: "SUCCESS", parking });
    } else {
      res.json({ status: "NOTFOUND", message: "Could not find the requested spot" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.delete("/myParking", async (req, res) => {
  const { userID } = req.user;
  const { spotID } = req.body;
  try {
    const parking = await ParkingLocations.findOne({ userID, slotID: spotID });
    if (parking) {
      await ParkingLocations.findOneAndDelete({ userID, slotID: spotID });
      res.json({ status: "SUCCESS", message: "deleted" });
    } else {
      res.json({ status: "NOTFOUND", message: "Could not find the requested spot" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.get("/bookings", async (req, res) => {
  const { userID } = req.user;
  try {
    const bookings = await ParkingHistory.find({ userID });
    res.json({ status: "SUCCESS", bookings });
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

module.exports = router;
