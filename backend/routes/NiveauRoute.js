const express = require('express')
const router = express.Router()
const {getNiveaux,SetNiveau,UpdateNiveau,DeleteNiveau} = require ('../controllers/NiveauController')
router.route('/').get(getNiveaux).post(SetNiveau)
router.route('/:id').delete(DeleteNiveau).put(UpdateNiveau)
module.exports = router