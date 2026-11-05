import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/features/auth/pages/profile_page.dart';
import 'package:burgero/features/cart/cubit/cart_cubit.dart';
import 'package:burgero/features/cart/cubit/cart_state.dart';
import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'package:burgero/features/cart/pages/cart_page.dart';
import 'package:burgero/features/home/pages/home_page.dart';
import 'package:burgero/features/order_history/cubit/order_history_cubit.dart';
import 'package:burgero/features/order_history/pages/order_history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController controller;

  int currentScreen = 0;
  int orderHistoryRefreshTrigger = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void completeOrder(CartCubit cartCubit) {
    cartCubit.completeOrder();

    setState(() {
      orderHistoryRefreshTrigger++;
    });
  }

  void orderAgain(CartCubit cartCubit, List<CartModel> items) {
    cartCubit.orderAgain(items);

    setState(() {
      currentScreen = 1;
    });

    controller.jumpToPage(1);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()..loadCart()),
        BlocProvider(create: (_) => OrderHistoryCubit()..loadOrders()),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartInitial || state is CartLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is CartFailure) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CartCubit>().loadCart();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is CartLoaded) {
                final cartCubit = context.read<CartCubit>();

                return Scaffold(
                  body: PageView(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      HomePage(onAddToCart: cartCubit.addToCart),
                      CartPage(
                        onOrderSuccess: () {
                          completeOrder(cartCubit);
                        },
                      ),
                      OrderHistoryPage(
                        onOrderAgain: (items) {
                          orderAgain(cartCubit, items);
                        },
                        refreshTrigger: orderHistoryRefreshTrigger,
                      ),
                      const ProfilePage(),
                    ],
                  ),
                  bottomNavigationBar: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: BottomNavigationBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.grey.shade500.withAlpha(180),
                      currentIndex: currentScreen,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.cart),
                          label: 'Cart',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.local_restaurant_sharp),
                          label: 'Order History',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.profile_circled),
                          label: 'Profile',
                        ),
                      ],
                      onTap: (index) {
                        setState(() {
                          currentScreen = index;
                        });

                        controller.jumpToPage(index);
                      },
                    ),
                  ),
                );
              }
              return const Scaffold();
            },
          );
        },
      ),
    );
  }
}
