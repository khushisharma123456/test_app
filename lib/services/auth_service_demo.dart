import '../models/user_models.dart';

class AuthService {
  // Demo mode - simulated authentication without Firebase
  AppUser? _currentUser;
  
  AppUser? get currentUser => _currentUser;
  
  Stream<AppUser?> get authStateChanges => 
      Stream.fromIterable([_currentUser]);

  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    required Language preferredLanguage,
  }) async {
    try {
      print('Demo: Signing up user with email: $email');
      
      // Simulate sign up process
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = AppUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        preferredLanguage: preferredLanguage,
        createdAt: DateTime.now(),
      );
      
      print('Demo: User signed up successfully');
      return null; // No error
    } catch (e) {
      print('Demo: Sign up error: $e');
      return e.toString();
    }
  }

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('Demo: Signing in user with email: $email');
      
      // Simulate sign in process
      await Future.delayed(const Duration(seconds: 1));
      
      // Demo user data
      _currentUser = AppUser(
        id: 'demo_user_id',
        name: email.contains('elderly') ? 'Demo Senior' : 'Demo Caregiver',
        email: email,
        role: email.contains('elderly') ? UserRole.elderly : UserRole.caregiver,
        preferredLanguage: Language.english,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      
      print('Demo: User signed in successfully');
      return null; // No error
    } catch (e) {
      print('Demo: Sign in error: $e');
      return e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      _currentUser = null;
      print('Demo: User signed out');
    } catch (e) {
      print('Demo: Sign out error: $e');
    }
  }

  Future<AppUser?> getUserData(String uid) async {
    try {
      print('Demo: Getting user data for: $uid');
      
      // Return current user for demo
      return _currentUser;
    } catch (e) {
      print('Demo: Get user data error: $e');
      return null;
    }
  }

  Future<void> updateUserData(AppUser user) async {
    try {
      print('Demo: Updating user data');
      _currentUser = user;
      print('Demo: User data updated');
    } catch (e) {
      print('Demo: Update user data error: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      print('Demo: Password reset email sent to: $email');
      // Simulate sending password reset email
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      print('Demo: Reset password error: $e');
    }
  }

  Future<AppUser?> getCurrentUser() async {
    // In demo mode, return current user or create a demo user
    if (_currentUser == null) {
      // Create a demo elderly user for testing
      _currentUser = AppUser(
        id: 'demo_user_1',
        name: 'Demo User',
        email: 'demo@example.com',
        role: UserRole.elderly,
        preferredLanguage: Language.english,
        createdAt: DateTime.now(),
      );
    }
    return _currentUser;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      print('Demo: Sending password reset email to: $email');
      await Future.delayed(const Duration(seconds: 1));
      print('Demo: Password reset email sent successfully');
      return true;
    } catch (e) {
      print('Demo: Error sending password reset email: $e');
      return false;
    }
  }
}
