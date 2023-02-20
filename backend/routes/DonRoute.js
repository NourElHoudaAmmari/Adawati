const express = require('express')
const router = express.Router()
const {getDons,SetDon,UpdateDon,DeleteDon} = require ('../controllers/DonsController')
router.route('/').get(getDons).post(SetDon)
router.route('/:id').delete(DeleteDon).put(UpdateDon)
module.exports = router