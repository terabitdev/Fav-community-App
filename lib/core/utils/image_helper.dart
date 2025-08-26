import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        return await imageFile.readAsBytes();
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  static Future<Uint8List?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        return await imageFile.readAsBytes();
      }
      return null;
    } catch (e) {
      debugPrint('Error capturing image from camera: $e');
      return null;
    }
  }

  static Future<List<Uint8List>?> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFiles.isNotEmpty) {
        List<Uint8List> imageBytesList = [];
        for (XFile file in pickedFiles) {
          final File imageFile = File(file.path);
          final bytes = await imageFile.readAsBytes();
          imageBytesList.add(bytes);
        }
        return imageBytesList;
      }
      return null;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return null;
    }
  }

  static String getImageSizeString(Uint8List bytes) {
    final kb = bytes.length / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(2)} KB';
    } else {
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(2)} MB';
    }
  }

  static bool isImageSizeValid(Uint8List bytes, {int maxSizeInMB = 5}) {
    final sizeInBytes = bytes.length;
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return sizeInBytes <= maxSizeInBytes;
  }
}