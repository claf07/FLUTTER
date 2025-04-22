
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../product_provider.dart';


class AddProducts extends StatelessWidget {
  const AddProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return MyForm();
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController ProductName = TextEditingController();
  final TextEditingController Price = TextEditingController();
  final TextEditingController description = TextEditingController();
  
  File? _selectedimage;
  String? uploadedurl;
  bool is_loading = false;

  Future<void> PickImage() async {
    final PickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        _selectedimage = File(PickedFile.path);
      });
    }
  }
  
 Future<void> Submit() async {
  double? FinalPrice = double.tryParse(Price.text);
  if (ProductName.text.isEmpty ||
      FinalPrice == null ||
      FinalPrice == 0 ||
      description.text.isEmpty ||
      _selectedimage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("All fields must be filled correctly!"),
        backgroundColor: const Color.fromARGB(189, 244, 67, 54),
      ),
    );
    return;
  }

  setState(() {
    is_loading = true;
  });

  try {
   final provider = Provider.of<ProductsProvider>(context, listen: false);

  await provider.addProduct(
  name: ProductName.text,
  price: double.parse(Price.text),
  description: description.text,
  image: _selectedimage!,
);


    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product Added Successfully"),
          backgroundColor: Colors.lightGreen,
          duration: Duration(seconds: 3),
        ),
      );
      reset();
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ),
      );
    }
    print(e);
  } finally {
    if (mounted) {
      setState(() {
        is_loading = false;
      });
    }
  }
}

  void reset() {
    setState(() {
      ProductName.clear();
      Price.clear();
      description.clear();
      _selectedimage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Color(0xfffbcfe8),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('porutkal Name', style: TextStyle(fontSize: 15)),
            SizedBox(height: 10),
            TextField(
              controller: ProductName,
              decoration: InputDecoration(
                labelText: 'Enter the porutkal Name',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: 13),
              ),
            ),
            SizedBox(height: 30),

            Text('Price', style: TextStyle(fontSize: 15)),
            SizedBox(height: 10),
            TextField(
              controller: Price,
              decoration: InputDecoration(
                labelText: 'Enter the Price',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: 13),
              ),
            ),
            SizedBox(height: 30),

            Text('Description', style: TextStyle(fontSize: 15)),
            SizedBox(height: 10),
            TextField(
              controller: description,
              decoration: InputDecoration(
                labelText: 'Enter the Description',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: 13),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: ElevatedButton(
                onPressed: () => PickImage(),
                child: Text('Add Image', style: TextStyle(fontSize: 15)),
              ),
            ),
            if (_selectedimage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Image.file(
                  _selectedimage!,
                  height: 150,
                ),
              ),
            if (is_loading==true)Center(child: CircularProgressIndicator(),),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: is_loading?null : Submit,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      foregroundColor: Color(0xff2563EB),
                      backgroundColor: Color(0xfffbcfe8),
                      fixedSize: Size(130, 30),
                    ),
                    child: Text('Submit', style: TextStyle(fontSize: 17)),
                  ),
                  SizedBox(width: 30),
                  OutlinedButton(
                    onPressed: () => reset(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      foregroundColor: Color(0xff2563EB),
                      backgroundColor: Color(0xfffbcfe8),
                      fixedSize: Size(130, 30),
                    ),
                    child: Text('Reset', style: TextStyle(fontSize: 17)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
