import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:small_test/page/config_page.dart';

class RootRouter {
  static final ValueNotifier<RoutingConfig> _configNotifier = ValueNotifier(_generateRouterConfig());
  static GoRouter rootRouter = GoRouter.routingConfig(routingConfig: _configNotifier);


  static RoutingConfig _generateRouterConfig() {
    return RoutingConfig(
      routes: [
        GoRoute(
          path: '/',
          name: 'config',
          builder: (context, state) => ConfigPage(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('About'),
            ),
          ),
        ),
      ],
    );
  }
}