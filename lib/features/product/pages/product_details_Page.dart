import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/features/chekout/widgets/topping_card.dart';
import 'package:burgero/features/product/data/models/product_model.dart';
import 'package:burgero/features/product/widgets/spicy_slider.dart';
import 'package:burgero/shared/custom_button.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final ProductModel product;

  final void Function(
    ProductModel product,
    List<String> toppings,
    List<String> sides,
    num unitPrice,
  )
  onAddToCart;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  double value = 0.5;

  final Map<String, num> toppings = {
    'Tomato': 5,
    'Onions': 5,
    'Pickles': 7,
    'Bacons': 20,
  };

  final Map<String, num> sideOptions = {
    'Fries': 30,
    'Coleslaw': 20,
    'Salad': 20,
    'Onion': 25,
  };

  final Map<String, String> toppingImages = {
    'Tomato': 'assets/detail/tomato.png',
    'Onions': 'assets/detail/onions.png',
    'Pickles': 'assets/detail/pickles.png',
    'Bacons': 'assets/detail/bacons.png',
  };

  final Map<String, String> sideImages = {
    'Fries': 'assets/detail/fries.png',
    'Coleslaw': 'assets/detail/coleslaw.png',
    'Salad': 'assets/detail/salad.png',
    'Onion': 'assets/detail/onion.png',
  };

  final Set<String> selectedToppings = {};
  final Set<String> selectedSides = {};

  num get totalPrice {
    num total = widget.product.price;
    for (final name in selectedToppings) {
      total += toppings[name]!;
    }
    for (final name in selectedSides) {
      total += sideOptions[name]!;
    }
    return total;
  }

  Widget buildOptions({
    required Map<String, num> options,
    required Map<String, String> images,
    required Set<String> selectedItems,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.keys.map((name) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ToppingCard(
              name: name,
              image: images[name]!,
              price: options[name]!,
              isSelected: selectedItems.contains(name),
              onTap: () {
                setState(() {
                  if (selectedItems.contains(name)) {
                    selectedItems.remove(name);
                  } else {
                    selectedItems.add(name);
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 210,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.fastfood_outlined,
                    size: 65,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const Gap(20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.product.name,
                        size: 23,
                        weight: FontWeight.bold,
                      ),
                      const Gap(6),
                      CustomText(
                        text: widget.product.description,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: CustomText(
                    text: '${widget.product.price} EGP',
                    size: 15,
                    weight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Gap(25),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SpicySlider(
                value: value,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                },
              ),
            ),
            const Gap(28),
            Row(
              children: [
                CustomText(text: 'Toppings', size: 20, weight: FontWeight.bold),
                const Spacer(),
                CustomText(text: 'Optional', size: 12, color: Colors.grey),
              ],
            ),
            const Gap(28),
            buildOptions(
              options: toppings,
              images: toppingImages,
              selectedItems: selectedToppings,
            ),
            const Gap(30),
            Row(
              children: [
                CustomText(
                  text: 'Side options',
                  size: 20,
                  weight: FontWeight.bold,
                ),
                const Spacer(),
                CustomText(text: 'Optional', size: 12, color: Colors.grey),
              ],
            ),
            const Gap(28),
            buildOptions(
              options: sideOptions,
              images: sideImages,
              selectedItems: selectedSides,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: 'Total price', size: 13, color: Colors.grey),
                  const Gap(4),
                  CustomText(
                    text: '${totalPrice.toStringAsFixed(0)} EGP',
                    size: 23,
                    weight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            CustomButton(
              text: 'Add To Cart',
              onTap: () {
                widget.onAddToCart(
                  widget.product,
                  selectedToppings.toList(),
                  selectedSides.toList(),
                  totalPrice,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to cart successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );

                Navigator.pop(context);
              },
              width: 145,
            ),
          ],
        ),
      ),
    );
  }
}
