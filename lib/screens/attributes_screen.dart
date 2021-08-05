import 'package:flutter/material.dart';
import 'package:product_database_task/helpers/db_helpers.dart';
import 'package:product_database_task/models/attributes_models.dart';

class AttributesScreen extends StatefulWidget {
  @override
  _AttributesScreenState createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _addAttribute = TextEditingController();
  late Future fetchAttribute;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAttribute = dbhattribute.getAllAttribute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Attribute"),
        backgroundColor: Color(0xff457b9d),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openForm();
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: fetchAttribute,
            builder: (context, AsyncSnapshot ss) {
              if (ss.hasError) {
                return Center(
                  child: Text("ERROR: ${ss.error}"),
                );
              } else {
                if (ss.hasData) {
                  List<Attribute> data = ss.data;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Text("${data[i].id}"),
                        title: Text("${data[i].attribute}"),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await dbhattribute.deleteRecord(data[i].id);
                                setState(() {
                                  fetchAttribute =
                                      dbhattribute.getAllAttribute();
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  openForm() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Attribute"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter Attribute .....";
                      }
                      return null;
                    },
                    controller: _addAttribute,
                    decoration: InputDecoration(
                      hintText: "Enter Attribute",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  _addAttribute.clear();
                  Navigator.of(context).pop();
                },
                child: Text("cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    int number = await dbhattribute.insertAttributes(
                      s: Attribute(
                        attribute: _addAttribute.text,
                      ),
                    );
                    _addAttribute.clear();
                    refreshData();
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Data inserted at Id: $number"),
                      ),
                    );
                  }
                },
                child: Text("Add"),
              ),
            ],
          );
        });
  }

  refreshData() {
    setState(() {
      fetchAttribute = dbhattribute.getAllAttribute();
    });
  }
}
