const express = require('express')
const router = express.Router()
const {getEtats,SetEtat,UpdateEtat,DeleteEtat} = require ('../controllers/EtatController')
router.route('/').get(getEtats).post(SetEtat)
router.route('/:id').delete(DeleteEtat).put(UpdateEtat)
module.exports = router