// Demo version without Firebase - fully functional for testing
import '../models/user_models.dart';

class AuthService {
  // Demo mode - simulated authentication without Firebase
  AppUser? _currentUser;
  
  AppUser? get currentUser => _currentUser;
  
  Stream<AppUser?> get authStateChanges => 
      Stream.fromIterable([_currentUser]);

  Future<AppUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    Language preferredLanguage = Language.english,
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
      return _currentUser;
    } catch (e) {
      print('Demo: Sign up error: $e');
      return null;
    }
  }

  Future<AppUser?> signInWithEmailAndPassword({
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
      return _currentUser;
    } catch (e) {
      print('Demo: Sign in error: $e');
      return null;
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
      return _currentUser;
    } catch (e) {
      print('Demo: Get user data error: $e');
      return null;
    }
  }

  Future<bool> updateUserData(AppUser user) async {
    try {
      print('Demo: Updating user data');
      _currentUser = user;
      print('Demo: User data updated');
      return true;
    } catch (e) {
      print('Demo: Update user data error: $e');
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      print('Demo: Password reset email sent to: $email');
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      print('Demo: Reset password error: $e');
      return false;
    }
  }
}
