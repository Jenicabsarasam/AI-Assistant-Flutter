import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../helper/global.dart';

class APIs {
  // Text generation with Gemini
  static Future<String> getAnswer(String question) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final response = await model.generateContent(
        [Content.text(question)],
        safetySettings: [
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        ],
      );
      return response.text ?? 'No response received';
    } catch (e) {
      log('Gemini error: $e');
      return 'Error getting response. Please try again.';
    }
  }
  

  // Image generation with reliable API
 static Future<Uint8List> generateAiImages(String prompt) async {
  try {
    final url = Uri.parse('https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer API Key', 
        'Accept': 'image/png',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'inputs': prompt}),
    );

    log('API response code: ${response.statusCode}');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else if (response.statusCode == 503) {
      // The model is loading
      final estimatedTime = (jsonDecode(utf8.decode(response.bodyBytes))['estimated_time'] ?? 10).ceil();
      log('Model is loading. Retrying after $estimatedTime seconds...');
      await Future.delayed(Duration(seconds: estimatedTime));
      return await generateAiImages(prompt);
    } else {
      final error = utf8.decode(response.bodyBytes);
      log('Error: $error');
      throw Exception('Image generation failed: $error');
    }
  } catch (e) {
    log('Exception in generateAiImages: $e');
    rethrow;
  }
}
}