import 'package:flutter/material.dart';
import 'package:product_database_task/screens/attributes_screen.dart';
import 'package:product_database_task/screens/product_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: Color(0xffa8dadc)),
      routes: {
        "/": (context) => HomePage(),
        "product_screen": (context) => ProductScreen(),
        "attributes_screen": (context) => AttributesScreen(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("List Of Product"),
          backgroundColor: Color(0xff457b9d),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("attributes_screen");
                },
                child: Text("ADD PRODUCT ATTRIBUTES"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("product_screen");
                },
                child: Text("ADD NEW PRODUCT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
