// Library Imports
const mongoose = require("mongoose");
const { v4: UUID } = require("uuid");

const ParkingLocationsSchema = mongoose.Schema({
  userID: { type: String, required: true },
  Location: {
    type: {
      type: String,
      enum: ["Point", "Polygon"],
    },
    coordinates: [Number],
  },
  address:String,
  slotID: { type: String, default: UUID },
  isEmpty: { type: Boolean, default: true },
  activeHours: { start: { type: Number, default: 0 }, end: { type: Number, default: 1440 } },
});
ParkingLocationsSchema.index({ Location: "2dsphere" });

const ParkingLocations = mongoose.model("parkinglocations", ParkingLocationsSchema);

module.exports = ParkingLocations;
