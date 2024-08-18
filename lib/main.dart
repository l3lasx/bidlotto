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

final GoRouter _router = GoRouter(
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
            // TODO: Implement CartPage
            return const Scaffold(body: Center(child: Text('Cart Page')));
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
            // TODO: Implement HistoryPage
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
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Validate'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors
              .transparent, // เปลี่ยนเป็น transparent เพื่อให้เห็น gradient
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          showSelectedLabels: false,
          showUnselectedLabels: false,
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        theme: ThemeData(
          textTheme: GoogleFonts.promptTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        title: 'Bidlotto',
        routerConfig: _router,
      ),
    );
  }
}
