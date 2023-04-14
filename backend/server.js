const express = require('express')
const dotenv = require('dotenv').config()
const {errorHandler}=require('./middleware/errorMiddleware')
const colors = require ('colors')
const connectDB = require('./config/db')
const { default: mongoose } = require('mongoose')
const port = process.env.PORT || 5000

mongoose.set('strictQuery',true)
connectDB()
const app = express()

app.use(express.json())
app.use(express.urlencoded({extended:false}))

app.use('/categories',require('./routes/CategorieRoute'))
app.use('/niveaux',require('./routes/NiveauRoute'))
app.use('/etats',require('./routes/EtatRoute'))
app.use('/matieres',require('./routes/MatiereRoute'))
app.use('/dons',require('./routes/DonRoute'))
app.use('/users',require('./routes/UserRoute'))


app.use(errorHandler)

app.listen(port,()=> console.log(`Server started on port ${port}`))