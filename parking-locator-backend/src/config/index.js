module.exports = {
  PORT: process.env.port || 5000,
  MONGODB_URI: process.env.MONGODB_URI || "mongodb+srv://parkingApp:JA2T8IQrBPDqgZUN@cluster.bhj6a.mongodb.net/parkingFinder?retryWrites=true&w=majority",
  JWT_SECRET: "secret",
  TIME_FORMAT: "HH:mm:ss",
};
