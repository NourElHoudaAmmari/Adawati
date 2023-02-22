const asyncHandler = require('express-async-handler')
const Categorie= require('../models/CategorieModel')


const getCategories = asyncHandler(async (req, res) => {
  const categories = await Categorie.find()

  res.status(200).json(categories)
})


const SetCategorie = asyncHandler(async (req, res) => {
  if (!req.body.libelle) {
    res.status(400)
    throw new Error('Please add a text field')
  }

  const categorie = await Categorie.create({
    libelle: req.body.text,
  })

  res.status(200).json(categorie)
})


const UpdateCategorie = asyncHandler(async (req, res) => {
  const categorie= await Categorie.findById(req.params.id)

  if (!categorie) {
    res.status(400)
    throw new Error('Categorie not found')
  }

  const updatedCategorie = await Categorie.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
  })

  res.status(200).json(updatedCategorie)
})


const deleteCategorie = asyncHandler(async (req, res) => {
  const categorie = await Categorie.findById(req.params.id)

  if (!categorie) {
    res.status(400)
    throw new Error('Categorie not found')
  }

  

  await categorie.remove()

  res.status(200).json({ id: req.params.id })
})

module.exports = {
  getCategories,
  SetCategorie,
  UpdateCategorie,
  deleteCategorie,
}
