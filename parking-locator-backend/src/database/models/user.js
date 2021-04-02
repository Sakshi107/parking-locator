// Library Imports
const mongoose = require("mongoose");
const { v4: UUID } = require("uuid");

const UserSchema = mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  mobile: { type: String, required: true },
  password: { type: String, required: true },
  walletBalance: { type: Number, default: 100 },
  userID: { type: String, default: UUID },
});

const User = mongoose.model("users", UserSchema);

module.exports = User;
