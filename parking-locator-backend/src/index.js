// Library Imports
require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const database = require("./database/connect");
const { PORT, MONGODB_URI } = require("./config");
const baseRouter = require("./routes");

const app = express();
app.use(cors());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use((err, req, res, next) => {
  if (err) {
    res.status(400).send({ message: "Error Parsing Data." });
  } else {
    next();
  }
});

// Connect to database
database.connectDB((err) => {
  if (err) {
    throw err;
  }
  app.use(baseRouter);

  app.use("/", (req, res) => res.send("api"));
  app.listen(PORT, () => {
    console.log(`listening to port ${PORT}`);
  });
});
// setup routes for the server
