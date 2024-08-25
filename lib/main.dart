import 'package:bidlotto/pages/cart.dart';
import 'package:bidlotto/pages/cart_result.dart';
import 'package:bidlotto/pages/home_user.dart';
import 'package:bidlotto/pages/home_validate.dart';
import 'package:bidlotto/pages/login.dart';
import 'package:bidlotto/pages/register.dart';
import 'package:bidlotto/pages/wallet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage();
      },
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeUserPage();
          },
        ),
        GoRoute(
          path: '/validate',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeValidate();
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (BuildContext context, GoRouterState state) {
            return const Cart();
          },
        ),
        GoRoute(
          path: '/cart_result',
          builder: (BuildContext context, GoRouterState state) {
            return const CartResult();
          },
        ),
        GoRoute(
          path: '/wallet',
          builder: (BuildContext context, GoRouterState state) {
            return const WalletPage();
          },
        ),
        GoRoute(
          path: '/history',
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: Center(child: Text('History Page')));
          },
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({Key? key, required this.child}) : super(key: key);
  final Widget child;
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [mainColor, darkerColor],
          ),
        ),
        child: SafeArea(
          child: CustomBottomNavigationBar(
            currentIndex: _calculateSelectedIndex(context),
            onTap: (int idx) => _onItemTapped(idx, context),
          ),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/validate')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/wallet')) return 3;
    if (location.startsWith('/history')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/validate');
        break;
      case 2:
        GoRouter.of(context).go('/cart');
        break;
      case 3:
        GoRouter.of(context).go('/wallet');
        break;
      case 4:
        GoRouter.of(context).go('/history');
        break;
    }
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.check, 'Validate', 1),
          _buildNavItem(Icons.shopping_cart, 'Cart', 2),
          _buildNavItem(Icons.account_balance_wallet, 'Wallet', 3),
          _buildNavItem(Icons.history, 'History', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: isSelected ? 26 : 22,
              ),
              if (isSelected)
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.promptTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        title: 'Bidlotto',
        routerConfig: router,
      ),
    );
  }
}
