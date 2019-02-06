import 'package:flutter/material.dart';
import './products.dart';

import '../../models/product.dart';

class ProductManager extends StatelessWidget {
  final List<Product> products;

  ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    return Products();
  }
}
