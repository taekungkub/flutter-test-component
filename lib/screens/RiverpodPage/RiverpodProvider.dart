import 'package:flutter_infinite_scroll/screens/RiverpodPage/RiverpodNotifier.dart';
import 'package:riverpod/riverpod.dart';

String helloWorld(ref) {
  return 'Hello world';
}

final productList = [
  const Product(id: 1, name: 'Product 1', description: 'This is the first product', price: 10.99),
  const Product(id: 2, name: 'Product 2', description: 'This is the second product', price: 19.99),
  const Product(id: 3, name: 'Product 3', description: 'This is the third product', price: 5.99),
];

final productProvider = Provider((ref) => productList);

class Product {
  final int id;
  final String name;
  final String description;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}
