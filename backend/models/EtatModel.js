const mongoose = require('mongoose')

const etatSchema = mongoose.Schema(
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

module.exports = mongoose.model('etat', etatSchema)