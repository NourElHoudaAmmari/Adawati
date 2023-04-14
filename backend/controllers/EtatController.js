const asyncHandler = require('express-async-handler')
const Etat = require('../Models/EtatModel')

const getEtats = asyncHandler (async (req,res) => {
   const etats = await Etat.find()
    res.status(200).json(etats)
})


const SetEtat = asyncHandler(async (req, res) => {
    const { libelle } = req.body
    //Check if champ vide
    if (!req.body) {
      res.status(400)
      throw new Error('Please add all fields')
    }
  
    // Create Etat
    const etat = await Etat.create({
     libelle:req.body
    })
    res.status(200).json(etat)
    res.send("Etat Record Added Successfully")
})

const UpdateEtat = asyncHandler(async (req, res) => {
    const etat= await Etat.findById(req.params.id)
    if(!etat){
        res.status(400)
        throw new Error('Etat not found')
    }
    const updatedEtat = await Etat.findByIdAndUpdate(req.params.id,req.
        body,{
            new: true,
        })
    res.status(200).json(updatedEtat)
    res.send("Etat updated Successfully")
})

const DeleteEtat =asyncHandler( async(req,res)=>{
    const etat = await Etat.findById(req.params.id)
    if(!etat){
        res.status(400)
        throw new Error('etat not found')
    }
    await etat.remove()
    res.status(200).json({id: req.params.id})
    res.send("Etat deleted Successfully")
})

module.exports = {
    getEtats,
    SetEtat,
    UpdateEtat,
    DeleteEtat 

}


