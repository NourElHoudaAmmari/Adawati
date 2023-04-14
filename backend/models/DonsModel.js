const mongoose = require('mongoose')

const donSchema = mongoose.Schema(
  {
    
    titre: {
      type: String,
      required: [true, 'Please add a text value'],
    },
    description: {
        type: String,
        required: [true, 'Please add a text value'],
      },
      etat: {
        type: String,
        required: [true, 'Please add a text value'],
      },
    categorie: {
        type: String,
        required: [true, 'Please add a text value'],
      },
      image: {
        type: String,
        default:"",
       // required: [true, 'Please add a text value'],
      },
     
  },
  {
    timestamps: true,
  }
)

module.exports = mongoose.model('don', donSchema)
