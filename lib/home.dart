import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    final torchController = TorchController();

    return Scaffold(
      body: Center(
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Container(
            color: Colors.blueGrey.shade900,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 35,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Flashlight stays on as long\nas you touch the screen",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.blueGrey.shade500)
                      ),
                    ]
                  ),
                ),
                Image.asset(
                  "assets/images/morse_alphabet.png",
                  cacheWidth: (MediaQuery.of(context).devicePixelRatio * 200).round(),
                  color: Colors.blueGrey.shade800,
                ),
                Positioned(
                  right: 15,
                  bottom: 15,
                  child: Image.asset(
                    "assets/images/click_icon.png",
                    cacheWidth: (MediaQuery.of(context).devicePixelRatio * 35).round(),
                    width: 35,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTapDown: (details) {
                    if (!isTorchActive(torchController)) {
                      torchController.toggle();
                    }
                  },
                  onTapUp: (details) {
                    torchController.toggle();
                  },
                  onTapCancel: () {
                    torchController.toggle();
                  },
                ),
              ]
            ),
          )
        )
      )
    );
  }

  bool isTorchActive(TorchController torchController) {
    bool isActive = false;
    torchController.isTorchActive.then((value) {
      isActive = value ?? false;
    });
    print("Torch active: $isActive");
    return isActive;
  }
}
