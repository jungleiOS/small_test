import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              context.push('/config');
            },
            title: Text('ConfigPage'),
          ),
          ListTile(
            onTap: () {
              context.push('/color_extractor');
            },
            title: Text('ColorExtractorPage'),
          ),
        ],
      ),
    );
  }
}
