const jwt = require("jsonwebtoken")
const asyncHandler = require("express-async-handler")
const User = require("../models/UserModel")
const JWT_SECRET = process.env.JWT_SECRET;
const protect = async (req, res, next) => {
  try {
    
    let token = req.headers["authorization"].split(" ")[1]
    if (token) {
console.log(token)
      try {
        // Verify token
        const decoded = jwt.verify(token, process.env.JWT_SECRET)
        // Get user from the token
        req.user = await User.findById(decoded._id).select("-password")

        next()
      } catch (error) {

        console.log(error)
        res.status(401)
        throw new Error("Not authorized")
      }
    }

    if (!token) {
      console.log(token)
      res.status(401)
      return new Error("Not authorized, no token")
    }

  } catch (error) {
    return new Error("Not authorized, no token")

  }
}


module.exports = { protect }