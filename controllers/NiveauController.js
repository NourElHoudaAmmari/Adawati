const asyncHandler = require('express-async-handler')
const Niveau = require('../Models/NiveauModel')

const getNiveaux = asyncHandler (async (req,res) => {
   const niveaux = await Niveau.find()
    res.status(200).json(niveaux)
})


const SetNiveau = asyncHandler(async (req, res) => {
    const { libelle } = req.body
    //Check if champ vide
    if (!req.body) {
      res.status(400)
      throw new Error('Please add all fields')
    }
  
    // Create Niveau
    const niveau = await Niveau.create({
     libelle:req.body
    })
    res.status(200).json(niveau)
    res.send("Niveau Record Added Successfully")
})
//Update Niveau
const UpdateNiveau = asyncHandler(async (req, res) => {
    const niveau= await Niveau.findById(req.params.id)
    if(!niveau){
        res.status(400)
        throw new Error('Niveau not found')
    }
    const updatedNiveau = await Niveau.findByIdAndUpdate(req.params.id,req.
        body,{
            new: true,
        })
    res.status(200).json(updatedNiveau)
    res.send("Niveau updated Successfully")
})

const DeleteNiveau =asyncHandler( async(req,res)=>{
    const niveau = await Niveau.findById(req.params.id)
    if(!niveau){
        res.status(400)
        throw new Error('Niveau not found')
    }
    await niveau.remove()
    res.status(200).json({id: req.params.id})
    res.send("Niveau deleted Successfully")
})

module.exports = {
    getNiveaux,
    SetNiveau,
    UpdateNiveau,
    DeleteNiveau 

}


