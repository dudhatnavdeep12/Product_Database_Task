import 'package:flutter/material.dart';
import 'package:product_database_task/helpers/db_helper02.dart';
import 'package:product_database_task/helpers/db_helpers.dart';
import 'package:product_database_task/models/product_models.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextEditingController _type = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  AsyncSnapshot? ss1, ss2;

  late Future<List<Product>> fetchData;
  late Future fetchAttribute;

  @override
  void initState() {
    fetchData = dbHelper2.allProducts();
    fetchAttribute = dbhattribute.getAllAttribute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Product Screen"),
          backgroundColor: Color(0xff457b9d),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: fetchData,
          builder: (context, AsyncSnapshot ss) {
            if (ss.hasError) {
              return Center(
                child: Text("ERROR: ${ss.error}"),
              );
            } else {
              if (ss.hasData) {
                List<Product> data = ss.data;
                ss1 = ss;
                return FutureBuilder(
                    future: fetchAttribute,
                    builder: (context, AsyncSnapshot attributeSnapshot) {
                      if (attributeSnapshot.hasError) {
                        return Center(
                          child: Text(attributeSnapshot.error.toString()),
                        );
                      } else if (attributeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      ss2 = attributeSnapshot;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: Text(
                              "${data[i].id}",
                              style: TextStyle(
                                color: Colors.red,
                                letterSpacing: 1,
                                fontSize: 18,
                              ),
                            ),
                            title: Text(
                              "${data[i].name}",
                              style: TextStyle(
                                color: Colors.teal,
                                letterSpacing: 1,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${data[i].type}",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                letterSpacing: 1,
                                fontSize: 15,
                              ),
                            ),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await dbHelper2.deleteRecord(data[i].id);

                                    setState(() {
                                      fetchData = dbHelper2.allProducts();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                  ),
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${data[i].quantity}",
                                  style: TextStyle(
                                    color: Colors.brown,
                                    letterSpacing: 1,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            openForm();
          },
          label: Text("Add New Product"),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  openForm() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Product"),
            content: Form(
              key: _formKey1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter Product type .....";
                              }
                              return null;
                            },
                            controller: _type,
                            decoration: InputDecoration(
                              hintText: "Enter Product type",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter Product name .....";
                              }
                              return null;
                            },
                            controller: _name,
                            decoration: InputDecoration(
                              hintText: "Enter Product name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter Product quantity .....";
                              }
                              return null;
                            },
                            controller: _quantity,
                            decoration: InputDecoration(
                              hintText: "Enter Product quantity",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: ss2!.data.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      TextFormField(
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue.empty),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Please Enter Product Quantity First....";
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText:
                                              "${ss2!.data[index].attribute}",
                                          hintText:
                                              "Enter Product ${ss2!.data[index].attribute}",
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  _name.clear();
                  Navigator.of(context).pop();
                },
                child: Text("cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey1.currentState!.validate()) {
                    dbHelper2.addData(
                      products: Product(
                          type: _type.text,
                          name: _name.text,
                          quantity: int.parse(_quantity.text)),
                    );
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Add"),
              ),
            ],
          );
        });
  }

  refreshData() {
    setState(() {
      fetchData = dbHelper2.allProducts();
    });
  }
}
