class Product{
  final int id;
  final String? name;
  final String? desc;
  final double? price;

  Product({required this.id,required  this.name,required  this.desc,required  this.price});

  //convert proudct to json
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };

  //convert json to product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'well name is missing',
      desc: json['description'] ?? 'well description is missing',  
      price: json['price'] ?? 0.0,
    );
  }

}