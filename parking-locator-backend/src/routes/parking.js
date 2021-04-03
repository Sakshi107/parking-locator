const express = require("express");
const ParkingLocations = require("../database/models/parkingLocations");
const moment = require("moment");
const { TIME_FORMAT } = require("../config");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("parking discovery service");
});

router.get("/nearme", async (req, res) => {
  const { lat, long, radius = 1000 } = req.query;
  const currentTimeinMinutesFromStartOfDay = moment().diff(moment().startOf("day"), "minutes");
  try {
    const parkingsNearMe = await ParkingLocations.find(
      {
        Location: {
          $near: { $geometry: { type: "Point", coordinates: [lat, long] }, $maxDistance: radius },
        },
        $and: [
          { "activeHours.start": { $lte: currentTimeinMinutesFromStartOfDay } },
          { "activeHours.end": { $gte: currentTimeinMinutesFromStartOfDay } },
        ],
        isEmpty: true,
      },
      { slotID: 1, "Location.coordinates": 1 ,"address":1,"activeHours":1}
    );
    res.json({ status: "SUCCESS", parkings: parkingsNearMe });
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

router.get("/:spotID", async (req, res) => {
  try {
    const { spotID } = req.params;
    let parking = await ParkingLocations.findOne({ slotID: spotID });
    if (parking) {
      parking = parking.toJSON();
      parking.activeHours.start = moment().startOf("day").add(parking.activeHours.start, "minutes").format(TIME_FORMAT);
      parking.activeHours.end = moment().startOf("day").add(parking.activeHours.end, "minutes").format(TIME_FORMAT);
      console.log(parking.activeHours);
      res.json({ status: "SUCCESS", parking });
    } else {
      res.json({ status: "NOTFOUND", message: "Could not find the requested spot" });
    }
  } catch (error) {
    res.status(500).send({ message: error.message, errorType: error.name });
  }
});

module.exports = router;
