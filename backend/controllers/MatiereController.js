const asyncHandler = require('express-async-handler')
const Matiere = require('../Models/MatiereModel')

const getMatieres = asyncHandler (async (req,res) => {
   const matieres = await Matiere.find()
    res.status(200).json(matieres)
})


const SetMatiere = asyncHandler(async (req, res) => {
    const { libelle } = req.body
    //Check if champ vide
    if (!req.body) {
      res.status(400)
      throw new Error('Please add all fields')
    }
  
    // Create Matiere
    const matiere = await Matiere.create({
     libelle:req.body
    })
    res.status(200).json(matiere)
    res.send("Matiere Record Added Successfully")
})

const UpdateMatiere = asyncHandler(async (req, res) => {
    const matiere= await Matiere.findById(req.params.id)
    if(!matiere){
        res.status(400)
        throw new Error('Matiere not found')
    }
    const updatedMatiere = await Matiere.findByIdAndUpdate(req.params.id,req.
        body,{
            new: true,
        })
    res.status(200).json(updatedMatiere)
    res.send("Matiere updated Successfully")
})

const DeleteMatiere =asyncHandler( async(req,res)=>{
    const matiere = await Matiere.findById(req.params.id)
    if(!matiere){
        res.status(400)
        throw new Error('Matiere not found')
    }
    await matiere.remove()
    res.status(200).json({id: req.params.id})
    res.send("Matiere deleted Successfully")
})

module.exports = {
    getMatieres,
    SetMatiere,
    UpdateMatiere,
    DeleteMatiere 

}


