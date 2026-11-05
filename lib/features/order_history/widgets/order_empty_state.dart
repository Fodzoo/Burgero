
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderEmptyState extends StatelessWidget {
  const OrderEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 200),
        Icon(
          Icons.receipt_long_outlined,
          size: 65,
          color: Colors.grey,
        ),
        Gap(15),
        Center(
          child: Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Gap(5),
        Center(
          child: Text(
            'Your completed orders will appear here.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
