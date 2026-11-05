
import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'package:burgero/features/order_history/widgets/order_item_tile.dart';
import 'package:burgero/shared/custom_button.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.total,
    required this.status,
    required this.date,
    required this.items,
    required this.itemIds,
    required this.deletingItems,
    required this.onDeleteItem,
    required this.onOrderAgain,
  });

  final int orderNumber;
  final double total;
  final String status;
  final String? date;
  final List<CartModel> items;
  final List<String?> itemIds;
  final Set<String> deletingItems;
  final void Function(String itemId) onDeleteItem;
  final VoidCallback onOrderAgain;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: 'Order #$orderNumber',
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
                CustomText(
                  text: '${total.toStringAsFixed(2)} EGP',
                  weight: FontWeight.bold,
                ),
              ],
            ),
            const Gap(5),
            Text(
              'Status: $status',
              style: const TextStyle(color: Colors.grey),
            ),
            if (date != null)
              Text(
                date!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            const Gap(15),
            for (int itemIndex = 0;
            itemIndex < items.length;
            itemIndex++)
              OrderItemTile(
                item: items[itemIndex],
                isDeleting: itemIds[itemIndex] != null &&
                    deletingItems.contains(itemIds[itemIndex]),
                onDelete: () {
                  final itemId = itemIds[itemIndex];

                  if (itemId != null) {
                    onDeleteItem(itemId);
                  }
                },
              ),
            const Gap(5),
            CustomButton(
              text: 'Order Again',
              width: double.infinity,
              color: Colors.grey.shade400,
              onTap: onOrderAgain,
            ),
          ],
        ),
      ),
    );
  }
}
