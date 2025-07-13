import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_translation_service.dart';
import '../models/user_models.dart';
import '../services/voice_service.dart';

class CameraTranslationScreen extends StatefulWidget {
  final Language targetLanguage;
  
  const CameraTranslationScreen({
    super.key,
    required this.targetLanguage,
  });

  @override
  State<CameraTranslationScreen> createState() => _CameraTranslationScreenState();
}

class _CameraTranslationScreenState extends State<CameraTranslationScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isProcessing = false;
  String _extractedText = '';
  String _translatedText = '';
  final VoiceService _voiceService = VoiceService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _voiceService.initTts();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );
        await _controller!.initialize();
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Translate Labels'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _isProcessing ? null : _captureAndTranslate,
            icon: const Icon(Icons.camera_alt),
            tooltip: 'Capture & Translate',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing camera...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Camera Preview
        Positioned.fill(
          child: _controller != null 
              ? CameraPreview(_controller!)
              : const Center(
                  child: Text(
                    'Camera not available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
        
        // Overlay with instructions
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.camera_alt, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  'Point camera at product label',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Tap the camera button to translate',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        // Results Panel
        if (_extractedText.isNotEmpty)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Original Text:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _extractedText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  
                  if (_translatedText.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Translated (${_getLanguageName(widget.targetLanguage)}):',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        _translatedText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _speakTranslation,
                            icon: const Icon(Icons.volume_up),
                            label: const Text('Speak'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _retakePhoto,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retake'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        
        // Processing Overlay
        if (_isProcessing)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Processing image...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _captureAndTranslate() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Capture image
      final image = await _controller!.takePicture();
      
      // Extract text from image
      final extractedText = await CameraTranslationService.extractTextFromImage(image.path);
      
      if (extractedText.isNotEmpty) {
        // Translate text
        final languageCode = _getLanguageCode(widget.targetLanguage);
        final translatedText = await CameraTranslationService.translateText(
          extractedText, 
          languageCode,
        );
        
        setState(() {
          _extractedText = extractedText;
          _translatedText = translatedText;
        });
      } else {
        _showError('No text found in image. Please try again.');
      }
    } catch (e) {
      _showError('Error processing image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _speakTranslation() async {
    if (_translatedText.isNotEmpty) {
      await _voiceService.speak(_translatedText);
    }
  }

  void _retakePhoto() {
    setState(() {
      _extractedText = '';
      _translatedText = '';
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getLanguageCode(Language language) {
    switch (language) {
      case Language.hindi:
        return 'hi';
      case Language.spanish:
        return 'es';
      case Language.english:
      default:
        return 'en';
    }
  }

  String _getLanguageName(Language language) {
    switch (language) {
      case Language.hindi:
        return 'Hindi';
      case Language.spanish:
        return 'Spanish';
      case Language.english:
      default:
        return 'English';
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
