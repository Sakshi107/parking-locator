// Library Imports
var mongoose = require("mongoose");

// Project Imports
const { MONGODB_URI } = require("./../config");

const connectDB = (callback) => {
  console.log("connecting");
  mongoose.connect(
    MONGODB_URI,
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      useCreateIndex: true,
      useFindAndModify: false,
    },
    (err) => {
      if (err) {
        callback(err);
      } else {
        console.log("connected");
        callback(null);
      }
    }
  );
};

module.exports = { connectDB };
