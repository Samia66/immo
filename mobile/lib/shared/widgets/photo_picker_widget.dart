import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Multi-photo picker: shows a horizontal row of picked-photo thumbnails
/// (each removable) plus an "add photo" tile that opens a camera/gallery
/// picker sheet. Caps selection at [maxPhotos] (the backend accepts up to 10
/// files per attachments upload).
class PhotoPickerWidget extends StatelessWidget {
  const PhotoPickerWidget({
    super.key,
    required this.photos,
    required this.onChanged,
    this.maxPhotos = 10,
    this.label = 'Photos',
  });

  final List<XFile> photos;
  final ValueChanged<List<XFile>> onChanged;
  final int maxPhotos;
  final String label;

  Future<void> _pick(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Prendre une photo'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choisir dans la galerie'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    if (source == ImageSource.gallery) {
      final remaining = maxPhotos - photos.length;
      if (remaining <= 0) return;
      final picked = await picker.pickMultiImage(imageQuality: 85);
      final toAdd = picked.take(remaining).toList();
      if (toAdd.isNotEmpty) onChanged([...photos, ...toAdd]);
    } else {
      if (photos.length >= maxPhotos) return;
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) onChanged([...photos, picked]);
    }
  }

  void _remove(int index) {
    final next = [...photos]..removeAt(index);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label (${photos.length}/$maxPhotos)', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length + (photos.length < maxPhotos ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == photos.length) {
                return InkWell(
                  onTap: () => _pick(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.add_a_photo_outlined, color: theme.colorScheme.primary),
                  ),
                );
              }
              final file = photos[index];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(file.path),
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: InkWell(
                      onTap: () => _remove(index),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
