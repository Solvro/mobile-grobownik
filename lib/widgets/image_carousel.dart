import "package:flutter/material.dart";

import "../gen/assets.gen.dart";

class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: CarouselView(
        itemExtent: 280,
        shrinkExtent: 200,
        children: [
          for (int i = 0; i < 3; i++)
            Assets.images.grave.image(fit: BoxFit.cover, semanticLabel: "Zdjęcie grobu numer ${i + 1}"),
        ],
      ),
    );
  }
}
