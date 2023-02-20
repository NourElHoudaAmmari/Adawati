const express = require('express')
const router = express.Router()
const {getCategories,SetCategorie,UpdateCategorie,DeleteCategorie} = require ('../controllers/CategorieController')
router.route('/').get(getCategories).post(SetCategorie)
router.route('/:id').delete(DeleteCategorie).put(UpdateCategorie)
module.exports = router