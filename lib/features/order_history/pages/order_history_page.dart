import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'package:burgero/features/order_history/cubit/order_history_cubit.dart';
import 'package:burgero/features/order_history/cubit/order_history_state.dart';
import 'package:burgero/features/order_history/widgets/order_card.dart';
import 'package:burgero/features/order_history/widgets/order_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({
    super.key,
    required this.onOrderAgain,
    required this.refreshTrigger,
  });

  final void Function(List<CartModel> items) onOrderAgain;
  final int refreshTrigger;

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OrderHistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshTrigger != widget.refreshTrigger) {
      context.read<OrderHistoryCubit>().loadOrders();
    }
  }

  Future<void> deleteOrderItem(String itemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete item?'),
        content: const Text(
          'Are you sure you want to remove this item from your order history?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    context.read<OrderHistoryCubit>().deleteOrderItem(itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocListener<OrderHistoryCubit, OrderHistoryState>(
        listenWhen: (previous, current) =>
            previous.successMessage != current.successMessage ||
            previous.deleteErrorMessage != current.deleteErrorMessage,
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));

            context.read<OrderHistoryCubit>().clearMessages();
          }

          if (state.deleteErrorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.deleteErrorMessage!),
                backgroundColor: Colors.red,
              ),
            );

            context.read<OrderHistoryCubit>().clearMessages();
          }
        },
        child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () {
                return context.read<OrderHistoryCubit>().loadOrders();
              },
              child: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(OrderHistoryState state) {
    if (state.isLoading) {
      return ListView(
        children: const [
          SizedBox(height: 250),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (state.errorMessage != null) {
      return ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Gap(100),
          const Icon(Icons.error_outline, size: 55, color: Colors.red),
          const Gap(15),
          const Center(
            child: Text(
              'Could not load orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Gap(10),
          Text(state.errorMessage!, textAlign: TextAlign.center),
          const Gap(15),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<OrderHistoryCubit>().loadOrders();
              },
              child: const Text('Try again'),
            ),
          ),
        ],
      );
    }

    if (state.orders.isEmpty) {
      return const OrderEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 120),
      itemCount: state.orders.length,
      itemBuilder: (context, index) {
        final order = state.orders[index];

        final rawItems = (order['order_items'] as List<dynamic>? ?? [])
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        final cubit = context.read<OrderHistoryCubit>();

        final items = cubit.getCartItemsFromOrder(rawItems);
        final orderNumber = state.orders.length - index;
        final total = cubit.calculateTotal(order).toDouble();

        final itemIds = rawItems.map((item) => item['id']?.toString()).toList();

        return OrderCard(
          orderNumber: orderNumber,
          total: total,
          status: order['status']?.toString() ?? 'Pending',
          date: order['created_at'] != null
              ? _formatDate(order['created_at'].toString())
              : null,
          items: items,
          itemIds: itemIds,
          deletingItems: state.deletingItems,
          onDeleteItem: deleteOrderItem,
          onOrderAgain: () => widget.onOrderAgain(items),
        );
      },
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value)?.toLocal();

    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}
