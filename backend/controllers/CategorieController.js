const asyncHandler = require('express-async-handler')
const Categorie = require('../Models/CategorieModel')

const getCategories = asyncHandler (async (req,res) => {
   const categories = await Categorie.find()
    res.status(200).json(categories)
})


const SetCategorie = asyncHandler(async (req, res) => {
    const { libelle } = req.body
    //Check if champ vide
    if (!req.body) {
      res.status(400)
      throw new Error('Please add all fields')
    }
  
    // Create Categorie
    const categorie = await Categorie.create({
     libelle:req.body
    })
    res.status(200).json(categorie)
    res.send("Categorie Record Added Successfully")
})

const UpdateCategorie = asyncHandler(async (req, res) => {
    const categorie= await Categorie.findById(req.params.id)
    if(!categorie){
        res.status(400)
        throw new Error('Categorie not found')
    }
    const updatedCategorie = await Categorie.findByIdAndUpdate(req.params.id,req.
        body,{
            new: true
        })
    res.status(200).json(updatedCategorie)
    res.send("Categorie updated Successfully")
})

const DeleteCategorie =asyncHandler( async(req,res)=>{
    const categorie = await Categorie.findById(req.params.id)
    if(!categorie){
        res.status(400)
        throw new Error('Categorie not found')
    }
    await categorie.remove()
    res.status(200).json({id: req.params.id})
    res.send("Categorie deleted Successfully")
})

module.exports = {
    getCategories,
    SetCategorie,
    UpdateCategorie,
    DeleteCategorie 

}


