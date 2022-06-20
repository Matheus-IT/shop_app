import '../models/product.dart';
import './dummy_products.dart';

class ProductProvider {
  static final List<Product> _products = dummyData;

  static List<Product> fetchProducts() {
    return _products;
  }
}
