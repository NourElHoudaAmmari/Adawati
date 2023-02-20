const express = require('express')
const router = express.Router()
const {getMatieres,SetMatiere,UpdateMatiere,DeleteMatiere} = require ('../controllers/MatiereController')
router.route('/').get(getMatieres).post(SetMatiere)
router.route('/:id').delete(DeleteMatiere).put(UpdateMatiere)
module.exports = router