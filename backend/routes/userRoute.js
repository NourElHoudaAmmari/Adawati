const express = require("express")
const router = express.Router()
const {
  registerUser,
  loginUser,
  getMe,
  tokenIsValid,
} = require("../controllers/userController")
const { protect } = require("../middleware/authMiddleware")

router.post("/", registerUser)
router.post("/tokenIsValid",tokenIsValid)
router.post("/login", loginUser)
router.get("/me", protect, getMe)

module.exports = router