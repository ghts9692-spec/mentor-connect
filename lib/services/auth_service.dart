import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  // Simulate authentication for now
  Future<User?> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'user@example.com' && password == 'password') {
      return User(
        id: '1',
        name: 'John Doe',
        email: email,
        bio: 'Aspiring mentor and tech enthusiast.',
      );
    }
    return null;
  }

  Future<void> signOut() async {
    // Simulate sign out
  }
}
