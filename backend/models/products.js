const mongoose=require('mongoose')
const ProductSchema=mongoose.Schema(
    {
        name:{
            type:String,
            required:[true,'Please Enter the name']
        },
        price:{
            type:Number,
            required:[true,'Please Enter the quantity'],
            default:0
        },
        description:{
            type:String,
            required:[true,'Please Enter the description'],

        },
        image:{
            type:String,
            required:[true,'Please Enter the url of image'],
        },
    },
    {
        timestamps:true//it shows the time 
    }
)

const Product=mongoose.model('Products',ProductSchema);
//exporting the model for using across all the files
module.exports=Product;