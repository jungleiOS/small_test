import 'package:flutter/material.dart';
import 'package:small_test/router/root_router.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RootRouter.rootRouter,
    );
  }
}