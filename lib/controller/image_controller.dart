import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../apis/apis.dart';
import '../helper/global.dart';
import '../helper/my_dialog.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();
  final status = Status.none.obs;
  final generatedImage = Rx<Uint8List?>(null);
  final imagePath = ''.obs;
  final isLoading = false.obs;

  Future<void> generateImages() async {
    if (textC.text.trim().isEmpty) {
      MyDialog.info('Please describe an image to generate');
      return;
    }

    status.value = Status.loading;
    isLoading.value = true;
    generatedImage.value = null;
    imagePath.value = '';

    try {
      MyDialog.showLoadingDialog(message: 'Creating your image...');
      
      final imageBytes = await APIs.generateAiImages(textC.text);
      
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ai_image_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);
      
      generatedImage.value = imageBytes;
      imagePath.value = file.path;
      status.value = Status.complete;

      Get.back();
      MyDialog.success('Image created successfully!');
    } catch (e) {
      Get.back();
      status.value = Status.none;
      MyDialog.error(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadImage() async {
    if (generatedImage.value == null) return;

    try {
      isLoading.value = true;
      MyDialog.showLoadingDialog(message: 'Saving to gallery...');

      final result = await ImageGallerySaver.saveImage(
        generatedImage.value!,
        quality: 100,
        name: "ai_image_${DateTime.now().millisecondsSinceEpoch}",
      );

      Get.back();
      if (result['isSuccess'] == true) {
        MyDialog.success('Saved to gallery!');
      } else {
        throw Exception(result['errorMessage'] ?? 'Save failed');
      }
    } catch (e) {
      Get.back();
      MyDialog.error('Could not save: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareImage() async {
    if (imagePath.value.isEmpty) return;

    try {
      isLoading.value = true;
      MyDialog.showLoadingDialog(message: 'Preparing share...');

      await Share.shareXFiles(
        [XFile(imagePath.value)],
        text: 'AI generated image from $appName',
      );
    } catch (e) {
      Get.back();
      MyDialog.error('Share failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }

  @override
  void onClose() {
    textC.dispose();
    super.onClose();
  }
}