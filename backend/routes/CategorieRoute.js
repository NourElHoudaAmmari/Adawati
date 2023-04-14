const express = require('express')
const router = express.Router()
const {
    getCategories,
    SetCategorie,
    UpdateCategorie,
    deleteCategorie,
} = require('../controllers/CategorieController')
router.route('/').get(getCategories).post(SetCategorie)
router.route('/:id').delete(deleteCategorie).put(UpdateCategorie)
module.exports = router
