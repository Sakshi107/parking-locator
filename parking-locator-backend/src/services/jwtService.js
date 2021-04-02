const jwt = require("jsonwebtoken");
const { JWT_SECRET } = require("../config");
const generateJWTToken = (payload) => {
  const token = jwt.sign(payload, JWT_SECRET);
  return token;
};

module.exports = { generateJWTToken };
