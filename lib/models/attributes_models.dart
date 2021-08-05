class Attribute {
  int? id;
  String? attribute;

  Attribute({
    this.id,
    this.attribute,
  });

  static Attribute fromMap(Map<String, dynamic> map) {
    return Attribute(
      id: map["id"],
      attribute: map["attribute"],
    );
  }
}
