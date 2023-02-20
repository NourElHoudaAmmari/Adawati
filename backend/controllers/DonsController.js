const asyncHandler = require('express-async-handler')
const Don = require('../Models/DonsModel')

const getDons = asyncHandler (async (req,res) => {
   const dons = await Don.find()
    res.status(200).json(dons)
})


const SetDon = asyncHandler(async (req, res) => {
    //Check if champ vide
    if(!req.body.titre || !req.body.description){
      res.status(400)
      throw new Error('Please add all fields')
    }
  
    // Create Don
    const don = await Don.create({
       titre: req.body.titre,
       descroption: req.body.descroption,
       image: req.body.descroption,
       etat: req.body.etat,
       categorie: req.body.categorie,
    })
    res.status(200).json(don)
    res.send("Don Record Added Successfully")
})

const UpdateDon = asyncHandler(async (req, res) => {
    const don= await Don.findById(req.params.id)
    if(!don){
        res.status(400)
        throw new Error('Don not found')
    }
    const updatedDon= await Don.findByIdAndUpdate(req.params.id,req.
        body,{
            new: true
        })
    res.status(200).json(updatedDon)
    res.send("Don updated Successfully")
})

const DeleteDon =asyncHandler( async(req,res)=>{
    const don = await Don.findById(req.params.id)
    if(!don){
        res.status(400)
        throw new Error('don not found')
    }
    await don.remove()
    res.status(200).json({id: req.params.id})
    res.send("don deleted Successfully")
})

module.exports = {
    getDons,
    SetDon,
    UpdateDon,
    DeleteDon 

}


