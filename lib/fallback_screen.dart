import 'package:flutter/material.dart';

class FallbackScreen extends StatelessWidget {
  const FallbackScreen({super.key, required this.fallbackText});

  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      color: Colors.blueGrey.shade900,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Text(fallbackText),
    )));
  }
}
