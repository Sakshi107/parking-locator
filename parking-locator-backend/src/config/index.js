module.exports = {
  PORT: process.env.port || 5000,
  MONGODB_URI: process.env.MONGODB_URI || "",
  JWT_SECRET: "secret",
  TIME_FORMAT: "HH:mm:ss",
};
