const mongoose = require('mongoose')

const categorieSchema = mongoose.Schema(
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

module.exports = mongoose.model('Categorie', categorieSchema)
