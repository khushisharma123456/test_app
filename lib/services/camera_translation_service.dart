import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraTranslationService {
  static const String _translateApiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY';
  static const String _visionApiKey = 'YOUR_GOOGLE_VISION_API_KEY';
  
  // Demo mode - simulated OCR text extraction
  static Future<String> extractTextFromImage(String imagePath) async {
    try {
      // In demo mode, return sample text
      await Future.delayed(Duration(seconds: 2)); // Simulate processing
      
      // Simulate extracted text based on common grocery items
      List<String> sampleTexts = [
        'Milk 2%',
        'Bread Whole Wheat',
        'Eggs Grade A',
        'Apples Red Delicious',
        'Bananas',
        'Orange Juice',
        'Chicken Breast',
        'Rice Basmati',
      ];
      
      return sampleTexts[DateTime.now().millisecond % sampleTexts.length];
    } catch (e) {
      print('Error extracting text: $e');
      return 'Could not read text from image';
    }
  }
  
  // Demo mode - simulated translation
  static Future<String> translateText(String text, String targetLanguage) async {
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      
      // Demo translations
      Map<String, Map<String, String>> translations = {
        'Milk 2%': {
          'hi': 'दूध 2%',
          'es': 'Leche 2%',
        },
        'Bread Whole Wheat': {
          'hi': 'ब्रेड होल व्हीट',
          'es': 'Pan Integral',
        },
        'Eggs Grade A': {
          'hi': 'अंडे ग्रेड ए',
          'es': 'Huevos Grado A',
        },
        'Apples Red Delicious': {
          'hi': 'सेब लाल स्वादिष्ट',
          'es': 'Manzanas Rojas Deliciosas',
        },
        'Bananas': {
          'hi': 'केले',
          'es': 'Plátanos',
        },
      };
      
      if (translations.containsKey(text) && 
          translations[text]!.containsKey(targetLanguage)) {
        return translations[text]![targetLanguage]!;
      }
      
      return '$text (translated to $targetLanguage)';
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text if translation fails
    }
  }
  
  // Real Google Translate API call (for production)
  static Future<String> _realTranslateText(String text, String targetLanguage) async {
    try {
      final url = Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$_translateApiKey');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'target': targetLanguage,
          'format': 'text',
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['translations'][0]['translatedText'];
      } else {
        throw Exception('Translation API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Real translation error: $e');
      return text;
    }
  }
  
  // Real Google Vision API call (for production)
  static Future<String> _realExtractTextFromImage(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);
      
      final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$_visionApiKey');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'requests': [
            {
              'image': {'content': base64Image},
              'features': [
                {'type': 'TEXT_DETECTION', 'maxResults': 10}
              ]
            }
          ]
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final annotations = data['responses'][0]['textAnnotations'];
        if (annotations != null && annotations.isNotEmpty) {
          return annotations[0]['description'];
        }
      }
      
      throw Exception('No text found in image');
    } catch (e) {
      print('Real OCR error: $e');
      return 'Could not read text from image';
    }
  }
}
