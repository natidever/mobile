import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart'; // If using GetX (optional)

class ProductImageController extends GetxController {
  final picker = ImagePicker();
  final _images = RxList<XFile>([]); // Use RxList for reactive updates

  Future<void> pickImage() async {
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      _images.add(result);
    }
  }

  List<XFile> get images => _images;
}