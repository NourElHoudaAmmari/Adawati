const mongoose = require('mongoose')

const matiereSchema = mongoose.Schema(
  {
    
    libelle: {
      type: String,
      required: [true, 'Please add a text value'],
    },
     },
  {
    timestamps: true,
  }
)

module.exports = mongoose.model('matiere', matiereSchema)