import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghanim_law_app/features/main_pages/pre/pages/order_form/pre/view/widgets/image/delete_image_dialog.dart';
import 'package:image_picker/image_picker.dart';

class ShowImagesPickerdItem extends StatelessWidget {
  const ShowImagesPickerdItem({
    super.key,
    required this.image,
    required this.index,
  });

  final XFile image;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image.file(File(image.path), fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(image.name),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => showDeletePhotoDialog(index, "image", context),
          ),
        ],
      ),
    );
  }
}
