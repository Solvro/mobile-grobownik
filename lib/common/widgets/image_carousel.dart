import "package:flutter/material.dart";

import "../../app/l10n/app_localizations.dart";
import "../../gen/assets.gen.dart";
import "../network/directus_client.dart";

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({required this.photoIds, super.key});

  final List<String> photoIds;

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context)!.image_carousel_semantic_label;

    final images = photoIds.isEmpty
        ? [Assets.images.grave.image(fit: BoxFit.cover, semanticLabel: label)]
        : [
            for (var i = 0; i < photoIds.length; i++)
              Image.network(
                DirectusConfig.assetUrl(photoIds[i]),
                fit: BoxFit.cover,
                semanticLabel: "$label ${i + 1}",
                errorBuilder: (context, error, stackTrace) =>
                    Assets.images.grave.image(fit: BoxFit.cover, semanticLabel: label),
              ),
          ];

    return SizedBox(height: 300, child: CarouselView(itemExtent: 280, shrinkExtent: 200, children: images));
  }
}
