import 'package:flutter/material.dart';
import '../../services/voice_service.dart';
import '../../services/shopping_list_service.dart';
import '../../services/translation_service.dart';
import '../../models/user_models.dart';
import 'elderly_shopping_list.dart';
import 'my_caregivers_screen.dart';

class ElderlyDashboard extends StatefulWidget {
  const ElderlyDashboard({super.key});

  @override
  State<ElderlyDashboard> createState() => _ElderlyDashboardState();
}

class _ElderlyDashboardState extends State<ElderlyDashboard> {
  final VoiceService _voiceService = VoiceService();
  final ShoppingListService _listService = ShoppingListService();
  final TranslationService _translationService = TranslationService();
  
  bool _isListening = false;
  final String _currentList = '';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _voiceService.initSpeech();
    await _voiceService.initTts();
    await _voiceService.speakInstruction('welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.accessibility_new,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Hello!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ready to make your shopping list?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Main Action Buttons
              Expanded(
                child: Column(
                  children: [
                    // Voice Assistant Button
                    _buildLargeActionButton(
                      icon: _isListening ? Icons.mic : Icons.mic_none,
                      title: _isListening ? 'Listening...' : 'Add Item with Voice',
                      subtitle: 'Tap and speak to add items',
                      color: const Color(0xFF2196F3),
                      onTap: _toggleVoiceListening,
                      isActive: _isListening,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // View Shopping List Button
                    _buildLargeActionButton(
                      icon: Icons.list_alt,
                      title: 'View My List',
                      subtitle: 'See and manage your items',
                      color: const Color(0xFF4CAF50),
                      onTap: _viewShoppingList,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Caregivers Button - NEW
                    _buildLargeActionButton(
                      icon: Icons.people,
                      title: 'My Caregivers',
                      subtitle: 'Manage your care team',
                      color: const Color(0xFFFF9800),
                      onTap: _manageCaregivers,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Read List Aloud Button
                    _buildLargeActionButton(
                      icon: Icons.volume_up,
                      title: 'Read My List',
                      subtitle: 'Listen to your shopping list',
                      color: const Color(0xFF9C27B0),
                      onTap: _readListAloud,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Help Button
                    _buildLargeActionButton(
                      icon: Icons.help_outline,
                      title: 'Help',
                      subtitle: 'Learn how to use the app',
                      color: const Color(0xFF607D8B),
                      onTap: _showHelp,
                    ),
                  ],
                ),
              ),
              
              // Bottom Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF2196F3),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tap any button to hear instructions. Use voice commands for easy shopping.',
                        style: TextStyle(
                          color: Color(0xFF2196F3),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 48,
                color: isActive ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: isActive ? Colors.white70 : Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleVoiceListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _isListening = true;
      });
      
      await _voiceService.speakInstruction('add_item');
      
      // Wait for speech to finish
      await Future.delayed(const Duration(seconds: 2));
      
      await _voiceService.startListening(
        onResult: _handleVoiceResult,
      );
    }
  }

  Future<void> _handleVoiceResult(String result) async {
    setState(() {
      _isListening = false;
    });
    
    if (result.isNotEmpty) {
      String item = _voiceService.parseShoppingItem(result);
      
      if (item.isNotEmpty) {
        // Add item to list (this would integrate with Firebase in a real app)
        await _voiceService.speakInstruction('item_added');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added: $item'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        await _voiceService.speakInstruction('error');
      }
    }
  }

  void _viewShoppingList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ElderlyShoppingList()),
    );
  }

  void _manageCaregivers() {
    // For demo purposes, using a static elder ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyCaregiverScreen(
          elderId: 'elder1', // In a real app, this would be the current user's ID
        ),
      ),
    );
  }

  Future<void> _readListAloud() async {
    // In a real app, this would fetch the actual list from Firebase
    await _voiceService.speak('Your shopping list has: Milk, Bread, Apples, and Eggs.');
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'How to Use EaseCart',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎤 Voice Commands:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Tap "Add Item with Voice" and speak clearly'),
              Text('• Say items like "milk", "bread", "apples"'),
              SizedBox(height: 16),
              Text(
                '📝 Managing Your List:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Tap "View My List" to see all items'),
              Text('• Check off items as you shop'),
              SizedBox(height: 16),
              Text(
                '🔊 Listen to Your List:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Tap "Read My List" to hear all items'),
              Text('• Perfect for hands-free shopping'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _voiceService.speakInstruction('help');
            },
            child: const Text(
              'Got it!',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
