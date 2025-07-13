import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _speechEnabled = false;
  String _lastWords = '';

  // Initialize speech to text
  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  // Initialize text to speech
  Future<void> initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  // Start listening for speech
  Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
  }) async {
    if (!_speechEnabled) return;

    await _speechToText.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        onResult(_lastWords);
      },
      partialResults: true,
      onSoundLevelChange: (level) {
        // Handle sound level changes if needed
      },
    );
  }

  // Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  // Speak text
  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  // Stop speaking
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  // Set language for TTS
  Future<void> setTtsLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  // Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  // Get available languages
  Future<List<dynamic>> getAvailableLanguages() async {
    return await _flutterTts.getLanguages;
  }

  // Check if speech is available
  bool get isSpeechEnabled => _speechEnabled;

  // Check if currently listening
  bool get isListening => _speechToText.isListening;

  // Get last recognized words
  String get lastWords => _lastWords;

  // Get speech recognition status
  String get lastStatus => _speechToText.lastStatus.toString();

  // Convert speech result to shopping item suggestion
  String parseShoppingItem(String speechResult) {
    // Clean up the speech result
    String cleaned = speechResult.toLowerCase().trim();
    
    // Remove common speech artifacts
    cleaned = cleaned.replaceAll(RegExp(r'\b(add|buy|get|need|want)\b'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\b(to|the|a|an)\b'), '');
    cleaned = cleaned.trim();
    
    // Capitalize first letter
    if (cleaned.isNotEmpty) {
      cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    }
    
    return cleaned;
  }

  // Voice commands for elderly users
  Map<String, String> getElderlyVoiceCommands() {
    return {
      'help': 'Available commands: Add item, View list, Read list, Clear list',
      'add': 'What would you like to add to your shopping list?',
      'view': 'Opening your shopping list now',
      'read': 'I will read your shopping list',
      'clear': 'Are you sure you want to clear the list?',
      'done': 'Task completed successfully',
      'error': 'Sorry, I didn\'t understand. Please try again.',
    };
  }

  // Speak instructions for elderly users
  Future<void> speakInstruction(String instruction) async {
    Map<String, String> instructions = {
      'welcome': 'Welcome to EaseCart. Say "add item" to add something to your list, or "view list" to see your items.',
      'add_item': 'What would you like to add to your shopping list? Speak clearly after the beep.',
      'item_added': 'Item added to your list successfully.',
      'list_empty': 'Your shopping list is empty. Say "add item" to add something.',
      'list_complete': 'Great job! You have completed your shopping list.',
      'error': 'Sorry, I had trouble understanding. Please try speaking again.',
      'help': 'You can say: Add item, View my list, Read my list, or Help for more options.',
    };

    String textToSpeak = instructions[instruction] ?? instruction;
    await speak(textToSpeak);
  }

  // Dispose resources
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
  }
}
