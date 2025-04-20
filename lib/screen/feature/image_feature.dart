import 'package:ai_assistant/controller/image_controller.dart';
import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ImageFeature extends StatelessWidget {
  ImageFeature({super.key});
  final _c = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Generator'),
        actions: [
          Obx(() {
            return _c.status.value == Status.complete
                ? IconButton(
                    onPressed: _c.shareImage,
                    icon: const Icon(Icons.share),
                  )
                : const SizedBox();
          }),
        ],
      ),
      floatingActionButton: Obx(() {
        if (_c.status.value == Status.complete) {
          return FloatingActionButton(
            onPressed: _c.downloadImage,
            child: const Icon(Icons.download),
          );
        }
        return const SizedBox(); // Always return a Widget
      }),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * .04,
          vertical: mq.height * .02,
        ),
        children: [
          // Search Box
          TextField(
            controller: _c.textC,
            decoration: InputDecoration(
              hintText: 'Describe the image you want...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _c.generateImages,
              ),
            ),
            onSubmitted: (_) => _c.generateImages(),
          ),
          SizedBox(height: mq.height * .03),

          // Results
          Obx(() {
            switch (_c.status.value) {
              case Status.none:
                return Column(
                  children: [
                    SizedBox(height: mq.height * .1),
                    Lottie.asset('assets/lottie/drawing.json', height: mq.height * .3),
                    Text(
                      'Your AI-generated image will appear here',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                );
              case Status.loading:
                return const SizedBox();
              case Status.complete:
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        _c.generatedImage.value!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
            }
          }),
        ],
      ),
    );
  }
}