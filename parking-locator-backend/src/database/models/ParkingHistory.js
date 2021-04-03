// Library Imports
const mongoose = require("mongoose");
const ParkingHistorySchema = mongoose.Schema({
  userID: { type: String, required: true },
  isConfirmed: { type: Boolean, default: false },
  startTime: { type: Date },
  endTime: { type: Date },
  advancedBooking: { type: Boolean },
  estimatedStartTime: { type: Date },
  estimatedEndTime: { type: Number },
  duration: { type: Number },
  slotID: { type: String, required: true },
});

const ParkingHistory = mongoose.model("parkingHistory", ParkingHistorySchema);

module.exports = ParkingHistory;
