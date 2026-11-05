import 'package:burgero/features/product/data/models/product_model.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  final List<ProductModel> products;

  ProductsSuccess(this.products);
}

class ProductsFailure extends ProductsState {
  final String message;

  ProductsFailure(this.message);
}
