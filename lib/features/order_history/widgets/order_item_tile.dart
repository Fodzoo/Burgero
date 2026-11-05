
import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({
    super.key,
    required this.item,
    required this.isDeleting,
    required this.onDelete,
  });

  final CartModel item;
  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.product.imageUrl.isEmpty
                ? const SizedBox(
              width: 75,
              height: 75,
              child: Icon(Icons.fastfood, size: 35),
            )
                : Image.network(
              item.product.imageUrl,
              width: 75,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 75,
                height: 75,
                child: Icon(Icons.fastfood, size: 35),
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item.product.name,
                  weight: FontWeight.bold,
                ),
                CustomText(text: 'Qty: ${item.quantity}'),
                CustomText(
                  text:
                  'Price: ${(item.unitPrice * item.quantity).toStringAsFixed(2)} EGP',
                ),
                if (item.toppings.isNotEmpty)
                  CustomText(
                    text: 'Toppings: ${item.toppings.join(', ')}',
                    size: 12,
                  ),
                if (item.sides.isNotEmpty)
                  CustomText(
                    text: 'Sides: ${item.sides.join(', ')}',
                    size: 12,
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete item',
            onPressed: isDeleting ? null : onDelete,
            icon: isDeleting
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
