const express = require('express');
const mongoose=require('mongoose');
const productroute=require('./routes/products.routes')

const app = express();
app.use(express.json({limit:'50mb'}));
const dotenv=require('dotenv');
app.use("/api/products",productroute);
dotenv.config();
app.listen((3000),()=> {
  console.log('Server is running on port 3000');
});

mongoose.connect(process.env.MONGO_CONNECTION_STRING)
.then(()=>{
console.log('connected successfully');
})
.catch((err)=>{
console.log('connection failed',err);
})

