import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  int _selProductIndex;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Null> addProduct(String title, String description, double price,
      String location, String image, bool isFavorite) {
    _isLoading = true;
    notifyListeners();

    // final imageurl =
    //     'https://cdn.pixabay.com/photo/2015/10/02/12/00/chocolate-968457_960_720.jpg';

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'image': image,
      'isFavorite': isFavorite,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };

    return http
        .post("https://flutter-products-4e805.firebaseio.com/products.json",
            body: json.encode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      _products.add(Product(
          id: responseData["name"],
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id,
          title: title,
          description: description,
          price: price,
          isFavorite: isFavorite,
          location: location,
          image: image));
      _selProductIndex = null;

      _isLoading = false;
      notifyListeners();
    });
  }
}

mixin ProductsModelMixin on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products
          .where((Product product) => product.isFavorite)
          .toList(); //tolist automatically creates a new list. you don't need list.from
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (_selProductIndex == null) {
      return null;
    }
    return _products[_selProductIndex];
  }

  bool get getFavoritesOnly {
    return _showFavorites;
  }

  Future<Null> updateProduct(String title, String description, double price,
      String location, String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedData = {
      "title": title,
      "description": description,
      "location": location,
      "price": price,
      "image": image,
      "userEmail": selectedProduct.userEmail,
      "userId": selectedProduct.userId,
    };
    return http
        .put(
            "https://flutter-products-4e805.firebaseio.com/products/${selectedProduct.id}.json",
            body: json.encode(updatedData))
        .then((http.Response response) {
      _isLoading = false;
      _products[_selProductIndex] = Product(
          id: selectedProduct.id,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id,
          isFavorite: selectedProduct.isFavorite,
          title: title,
          description: description,
          price: price,
          location: location,
          image: image);
      _selProductIndex = null;
      notifyListeners();
    });
  }

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(_selProductIndex);
    _selProductIndex = null;
    notifyListeners();

    http
        .delete(
            "https://flutter-products-4e805.firebaseio.com/products/$deletedProductId.json")
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        location: selectedProduct.location,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[_selProductIndex] = updatedProduct;
    _selProductIndex = null;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    if (index != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    final List<Product> fetchedProductList = [];
    return http
        .get("https://flutter-products-4e805.firebaseio.com/products.json")
        .then((http.Response response) {
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData != null) {
        productListData.forEach((String key, dynamic productData) {
          final Product newProduct = Product(
            id: key,
            title: productData["title"],
            description: productData["description"],
            image: productData["image"],
            location: productData["location"],
            price: productData["price"],
            isFavorite: false,
            userEmail: productData["userEmail"],
            userId: productData["userId"],
          );
          fetchedProductList.add(newProduct);
        });
      }
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
  }
}

mixin UserModelMixin on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'asdf', email: email, password: password);
  }
}

mixin UtilityModelMixin on ConnectedProductsModel {
  bool get isLoading => _isLoading;
}
