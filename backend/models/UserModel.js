const mongoose = require('mongoose')
const userSchema = mongoose.Schema(

 {
    name: {
      type: String,
      required: [true, "Please add a name"],
    },
    email: {
      type: String,
      required: [true, "Please add an email"],
      unique: true,
      validate:{
validator:(value)=>{
  const re =
  /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
  return value.match(re)
},
      },
    },
    password: {
      type: String,
      required: [true, "Please add a password"],
    },
   
  },
  {
    timestamps: true,
  },
)
module.exports = mongoose.model("User", userSchema)
