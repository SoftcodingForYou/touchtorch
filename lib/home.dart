import 'package:flutter/material.dart';
import 'package:touchtorch/fallback_screen.dart';
import 'package:torch_light/torch_light.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _isTorchAvailable(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            return Center(
                child: Container(
              color: Colors.blueGrey.shade900,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(alignment: Alignment.center, children: [
                Positioned(
                  top: 35,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Flashlight stays on as long\nas you touch the screen",
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.blueGrey.shade500)),
                      ]),
                ),
                Image.asset(
                  "assets/images/morse_alphabet.png",
                  cacheWidth:
                      (MediaQuery.of(context).devicePixelRatio * 200).round(),
                  color: Colors.blueGrey.shade800,
                ),
                Positioned(
                  right: 15,
                  bottom: 15,
                  child: Image.asset(
                    "assets/images/click_icon.png",
                    cacheWidth:
                        (MediaQuery.of(context).devicePixelRatio * 35).round(),
                    width: 35,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTapDown: (details) async {
                    _enableTorch(context);
                  },
                  onTapUp: (details) async {
                    _disableTorch(context);
                  },
                  onPanEnd: (details) async {
                    _disableTorch(context);
                  },
                  onPanCancel: () async {
                    _disableTorch(context);
                  },
                ),
              ]),
            ));
          } else if (snapshot.hasData) {
            return const FallbackScreen(
                fallbackText: "Device's torch is not available.");
          } else {
            return const FallbackScreen(
                fallbackText:
                    "An unhandled situation occurred\n\nPlease, contact the developer of this app!");
          }
        },
      ),
    );
  }

  Future<bool> _isTorchAvailable(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Could not check if the device has an available torch'),
        ),
      );
      rethrow;
    }
  }

  Future<void> _enableTorch(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Could not enable torch'),
        ),
      );
    }
  }

  Future<void> _disableTorch(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Could not disable torch'),
        ),
      );
    }
  }
}
