import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_models.dart';

class TranslationService {
  static const String _apiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY'; // Replace with actual API key
  static const String _baseUrl = 'https://translation.googleapis.com/language/translate/v2';

  // Translate text to target language
  Future<String?> translateText({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'auto',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'q': text,
          'target': targetLanguage,
          'source': sourceLanguage,
          'format': 'text',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['translations'][0]['translatedText'];
      } else {
        print('Translation error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error translating text: $e');
      return null;
    }
  }

  // Detect language of text
  Future<String?> detectLanguage(String text) async {
    try {
      final response = await http.post(
        Uri.parse('https://translation.googleapis.com/language/translate/v2/detect?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'q': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['detections'][0][0]['language'];
      } else {
        print('Language detection error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error detecting language: $e');
      return null;
    }
  }

  // Get supported languages
  Future<Map<String, String>?> getSupportedLanguages() async {
    try {
      final response = await http.get(
        Uri.parse('https://translation.googleapis.com/language/translate/v2/languages?key=$_apiKey&target=en'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Map<String, String> languages = {};
        
        for (var lang in data['data']['languages']) {
          languages[lang['language']] = lang['name'];
        }
        
        return languages;
      } else {
        print('Get languages error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting supported languages: $e');
      return null;
    }
  }

  // Common shopping items translations (offline fallback)
  Map<String, Map<String, String>> getCommonItemTranslations() {
    return {
      'milk': {
        'es': 'leche',
        'fr': 'lait',
        'de': 'milch',
        'zh': '牛奶',
        'ar': 'حليب',
      },
      'bread': {
        'es': 'pan',
        'fr': 'pain',
        'de': 'brot',
        'zh': '面包',
        'ar': 'خبز',
      },
      'eggs': {
        'es': 'huevos',
        'fr': 'œufs',
        'de': 'eier',
        'zh': '鸡蛋',
        'ar': 'بيض',
      },
      'apples': {
        'es': 'manzanas',
        'fr': 'pommes',
        'de': 'äpfel',
        'zh': '苹果',
        'ar': 'تفاح',
      },
      'rice': {
        'es': 'arroz',
        'fr': 'riz',
        'de': 'reis',
        'zh': '大米',
        'ar': 'أرز',
      },
      'chicken': {
        'es': 'pollo',
        'fr': 'poulet',
        'de': 'hähnchen',
        'zh': '鸡肉',
        'ar': 'دجاج',
      },
      'water': {
        'es': 'agua',
        'fr': 'eau',
        'de': 'wasser',
        'zh': '水',
        'ar': 'ماء',
      },
      'cheese': {
        'es': 'queso',
        'fr': 'fromage',
        'de': 'käse',
        'zh': '奶酪',
        'ar': 'جبن',
      },
      'tomatoes': {
        'es': 'tomates',
        'fr': 'tomates',
        'de': 'tomaten',
        'zh': '西红柿',
        'ar': 'طماطم',
      },
      'onions': {
        'es': 'cebollas',
        'fr': 'oignons',
        'de': 'zwiebeln',
        'zh': '洋葱',
        'ar': 'بصل',
      },
    };
  }

  // Get offline translation if available
  String? getOfflineTranslation(String item, String targetLanguage) {
    final translations = getCommonItemTranslations();
    final itemLower = item.toLowerCase();
    
    if (translations.containsKey(itemLower)) {
      return translations[itemLower]![targetLanguage];
    }
    
    return null;
  }

  // Convert language enum to language code
  String getLanguageCode(Language language) {
    switch (language) {
      case Language.english:
        return 'en';
      case Language.spanish:
        return 'es';
      case Language.hindi:
        return 'hi';
      case Language.french:
        return 'fr';
      case Language.german:
        return 'de';
      case Language.chinese:
        return 'zh';
      case Language.arabic:
        return 'ar';
    }
  }

  // Get language name
  String getLanguageName(Language language) {
    switch (language) {
      case Language.english:
        return 'English';
      case Language.spanish:
        return 'Español';
      case Language.french:
        return 'Français';
      case Language.german:
        return 'Deutsch';
      case Language.chinese:
        return '中文';
      case Language.arabic:
        return 'العربية';
      case Language.hindi:
        return 'हिन्दी';
    }
  }

  // Translate shopping item with fallback
  Future<String> translateShoppingItem({
    required String item,
    required Language targetLanguage,
  }) async {
    String targetCode = getLanguageCode(targetLanguage);
    
    // Try offline translation first
    String? offlineTranslation = getOfflineTranslation(item, targetCode);
    if (offlineTranslation != null) {
      return offlineTranslation;
    }
    
    // Try online translation
    String? onlineTranslation = await translateText(
      text: item,
      targetLanguage: targetCode,
    );
    
    return onlineTranslation ?? item; // Return original if translation fails
  }
}
