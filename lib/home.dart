import 'package:flutter/material.dart';
import 'package:touchtorch/fallback_screen.dart';
import 'package:torch_light/torch_light.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isTorchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _isTorchAvailable(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            return GestureDetector(
              onTapDown: (_) => _toggleTorch(true),
              onTapUp: (_) => _toggleTorch(false),
              onPanEnd: (_) => _toggleTorch(false),
              onPanCancel: () => _toggleTorch(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                color: _isTorchOn
                    ? Colors.yellow.shade700
                    : Colors.blueGrey.shade900,
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Touch and hold the screen\nto turn on the flashlight",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueGrey.shade200,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Image.asset(
                              "assets/images/morse_alphabet.png",
                              cacheWidth: (MediaQuery.of(context)
                                          .devicePixelRatio *
                                      200)
                                  .round(),
                              color: Colors.blueGrey.shade800,
                            ),
                          ],
                        ),
                        Positioned(
                          right: 15,
                          bottom: 15,
                          child: Image.asset(
                            "assets/images/click_icon.png",
                            cacheWidth: (MediaQuery.of(context)
                                        .devicePixelRatio *
                                    35)
                                .round(),
                            width: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return const FallbackScreen(
              fallbackText: "Device's torch is not available.",
            );
          } else {
            return const FallbackScreen(
              fallbackText:
                  "An unexpected error occurred.\nPlease contact the developer.",
            );
          }
        },
      ),
    );
  }

  Future<bool> _isTorchAvailable(BuildContext context) async {
    try {
      return await TorchLight.isTorchAvailable();
    } catch (_) {
      _showError("Could not check if the device has a torch.");
      rethrow;
    }
  }

  Future<void> _toggleTorch(bool turnOn) async {
    if (_isTorchOn == turnOn) return;

    setState(() {
      _isTorchOn = turnOn;
    });

    try {
      if (turnOn) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (_) {
      _showError("Failed to ${turnOn ? "enable" : "disable"} torch.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

