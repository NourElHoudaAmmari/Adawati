const mongoose = require('mongoose')

const niveauSchema = mongoose.Schema(
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

module.exports = mongoose.model('niveau', niveauSchema)