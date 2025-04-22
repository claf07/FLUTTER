import 'package:flutter/material.dart';
import './viewproducts.dart';
import './addproducts.dart';
import './editproducts.dart';
import 'package:google_fonts/google_fonts.dart';


class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Dashboard',
        style: GoogleFonts.albertSans(
                  textStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  )
                ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:() {
              //
            }, 
            icon: Icon(Icons.menu))

        ],
        elevation: 1.8,
        backgroundColor: Color(0xfffbcfe8),
        ),
      body:
       Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            SizedBox(
             child:  Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
              child: Text(
                'Welcome to the Claffin Manager!\n\n'
                'Here, you can easily view, edit, change, or delete your products.\n',
                textAlign:TextAlign.center,
                softWrap: true,
                style: GoogleFonts.albertSans(
                  textStyle: TextStyle(
                    fontSize: 16
                  )
                ),

                ),),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewProductsPage()),
                    ); 
                   
                  },
                  
                  icon: Icon(Icons.view_carousel),
                  label: Text('View Products'),
                 style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xff2563EB),
                  backgroundColor: Color(0xfffbcfe8),
                  side: BorderSide.none,
                  fixedSize: Size(180, 50)
                 ),
                  ),
                OutlinedButton.icon(onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProducts()),
                    );  
                  },
                  icon: Icon(Icons.add_box_rounded),
                  label: Text('Add Products'),
                  style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xffDB2777),
                  backgroundColor: Color(0xffBFDBFE),
                  fixedSize: Size(180, 50),
                  side:BorderSide.none
                 ),
                ),
                     ],
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProductsScreen()),
                    );  
                  },
                  icon: Icon(Icons.edit),
                  label: FittedBox(child: Text('Change Products')),
                  style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xff2563EB),
                  backgroundColor: Color(0xfffbcfe8),
                  fixedSize: Size(180, 50),
                  side:BorderSide.none
                 ),
                ),
                 
              ],
            )
          ],
               ),
       );
  }
}