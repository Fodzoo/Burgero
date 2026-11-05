import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burgero/features/product/data/services/product_service.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final ProductService productService = ProductService();

  Future<void> getProducts() async {
    emit(ProductsLoading());

    try {
      final products = await productService.getProducts();

      emit(ProductsSuccess(products));
    } catch (error) {
      emit(ProductsFailure('Failed to load products.'));
    }
  }

  Future<void> retry() async {
    await getProducts();
  }
}