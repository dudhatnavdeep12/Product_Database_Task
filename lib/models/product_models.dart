class Product {
  int? id;
  final String type;
  final String name;
  final int quantity;

  Product(
      {this.id,
      required this.type,
      required this.name,
      required this.quantity});
  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map["id"],
      type: map["type"],
      name: map["name"],
      quantity: map["quantity"],
    );
  }
}
