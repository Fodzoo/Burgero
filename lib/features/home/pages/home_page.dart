import 'package:burgero/features/home/widgets/cart_item.dart';
import 'package:burgero/features/home/widgets/food_category.dart';
import 'package:burgero/features/home/widgets/search_field.dart';
import 'package:burgero/features/home/widgets/user_header.dart';

import 'package:burgero/features/product/data/models/product_model.dart';
import 'package:burgero/features/product/pages/product_details_Page.dart';

import 'package:burgero/core/constants/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../product/cubit/products_cubit.dart';
import '../../product/cubit/products_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onAddToCart});

  final void Function(
      ProductModel product,
      List<String> toppings,
      List<String> sides,
      num unitPrice,
      )
  onAddToCart;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> category = ["All", "Combo", "Sliders", "Classic"];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit()..getProducts(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Header + Search
            SliverAppBar(
              elevation: 0,
              pinned: true,
              floating: false,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 225,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 35, right: 20, left: 20),
                child: Column(children: [UserHeader(), Gap(20), SearchField()]),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: FoodCategory(
                  selectedIndex: selectedIndex,
                  category: category,
                  onSelected: (index) => setState(() => selectedIndex = index),
                ),
              ),
            ),

            // Products from Supabase using ProductsCubit
            SliverToBoxAdapter(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  // Loading
                  if (state is ProductsInitial || state is ProductsLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(50),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  // Error
                  if (state is ProductsFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const Text(
                            'Failed to load products.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Gap(10),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProductsCubit>().retry();
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Success
                  if (state is ProductsSuccess) {
                    // TODO: فلترة بالفئة بعد ما نضيف حقل category في ProductModel
                    final products = state.products;

                    if (products.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(child: Text('No products available.')),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final ProductModel product = products[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductDetailsPage(
                                    product: product,
                                    onAddToCart: widget.onAddToCart,
                                  );
                                },
                              ),
                            );
                          },
                          child: CartItem(
                            image: product.imageUrl,
                            text: product.name,
                            desc: product.description,
                            rate: '4.9',
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}