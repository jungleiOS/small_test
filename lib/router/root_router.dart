import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:small_test/page/color_extractor_page.dart';
import 'package:small_test/page/config_page.dart';
import 'package:small_test/page/home_page.dart';

class RootRouter {
  static final ValueNotifier<RoutingConfig> _configNotifier =
      ValueNotifier(_generateRouterConfig());
  static GoRouter rootRouter = GoRouter.routingConfig(
    routingConfig: _configNotifier,
    debugLogDiagnostics: true,
  );

  static RoutingConfig _generateRouterConfig() {
    return RoutingConfig(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: 'config',
              name: 'config',
              builder: (context, state) => ConfigPage(),
            ),
            GoRoute(
              path: 'color_extractor',
              name: 'color_extractor',
              builder: (context, state) => ColorExtractorPage(),
            ),
          ],
        ),
      ],
    );
  }
}
