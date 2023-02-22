
const mongoose = require("mongoose")

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
userSchema.set("toJSON",{
    transform:(document,returnedObject)=>{
        returnedObject.id =returnedObject._id.toString();
        delete returnedObject._id;
        delete returnedObject._v;
        delete returnedObject.password;
    },
});
//userSchema.plugin(uniqueValidator,{message:"email already in use"});
module.exports = mongoose.model("User", userSchema)