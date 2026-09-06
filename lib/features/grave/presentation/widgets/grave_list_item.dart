import "package:flutter/material.dart";

import "../../../../app/theme/app_theme.dart";
import "../../../../common/network/directus_client.dart";
import "../../../../common/utils/distance.dart";
import "../../data/models/grave.dart";

class GraveListItem extends StatelessWidget {
  const GraveListItem({required this.grave, required this.distanceMeters, required this.onTap, super.key});

  final Grave grave;
  final double? distanceMeters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photoId = grave.photoIds.isNotEmpty ? grave.photoIds.first : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: photoId != null
                  ? Image.network(
                      DirectusConfig.assetUrl(photoId),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const _GravePhotoPlaceholder(),
                    )
                  : const _GravePhotoPlaceholder(),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                "${grave.firstName} ${grave.lastName}",
                style: context.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),

            Text(formatDistance(distanceMeters), style: context.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _GravePhotoPlaceholder extends StatelessWidget {
  const _GravePhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: context.colorScheme.secondary,
      child: Icon(Icons.image_not_supported_outlined, color: context.colorScheme.onSurfaceVariant),
    );
  }
}
