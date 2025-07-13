import 'package:flutter/material.dart';
import '../models/user_models.dart';
import 'auth/login_screen.dart';
import 'elderly/elderly_dashboard.dart';
import 'caregiver/caregiver_dashboard.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF357ABD),
              Color(0xFF2E5F8A),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // App Logo and Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_cart_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'EaseCart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Smart Shopping Assistant\nfor Seniors & Caregivers',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Role Selection Title
                    const Text(
                      'Choose Your Experience',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Role Selection Cards
                    Expanded(
                      child: Column(
                        children: [
                          // Elderly Mode Card
                          _buildRoleCard(
                            icon: Icons.accessibility_new,
                            title: 'Elderly Mode',
                            subtitle: 'Simple interface with voice commands\nand large buttons',
                            color: const Color(0xFF4CAF50),
                            onTap: () => _navigateToRole(UserRole.elderly),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Caregiver Mode Card
                          _buildRoleCard(
                            icon: Icons.family_restroom,
                            title: 'Caregiver Mode',
                            subtitle: 'Manage lists for family members\nwith sharing and reminders',
                            color: const Color(0xFF2196F3),
                            onTap: () => _navigateToRole(UserRole.caregiver),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Language Selection
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Language: ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          DropdownButton<Language>(
                            value: Language.english,
                            dropdownColor: const Color(0xFF357ABD),
                            style: const TextStyle(color: Colors.white),
                            underline: Container(),
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                            items: Language.values.map((Language language) {
                              return DropdownMenuItem<Language>(
                                value: language,
                                child: Text(_getLanguageName(language)),
                              );
                            }).toList(),
                            onChanged: (Language? newValue) {
                              // Handle language change
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Already have account link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 48,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.arrow_forward,
              color: color,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRole(UserRole role) {
    if (role == UserRole.elderly) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ElderlyDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CaregiverDashboard()),
      );
    }
  }

  String _getLanguageName(Language language) {
    switch (language) {
      case Language.english:
        return 'English';
      case Language.spanish:
        return 'Español';
      case Language.hindi:
        return 'हिन्दी';
      case Language.french:
        return 'Français';
      case Language.german:
        return 'Deutsch';
      case Language.chinese:
        return '中文';
      case Language.arabic:
        return 'العربية';
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
