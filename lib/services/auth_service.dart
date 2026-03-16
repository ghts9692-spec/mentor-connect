import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'token_service.dart';

final authServiceProvider = Provider((ref) => AuthService(ref.read(apiServiceProvider)));

class AuthService {
  final ApiService _api;
  final _tokenService = TokenService();

  AuthService(this._api);

  /// Login with email + password. Saves JWT tokens and returns the User.
  Future<User> login(String email, String password) async {
    final data = await _api.post(
      '/auth/login/',
      {'email': email, 'password': password},
      auth: false,
    );
    await _tokenService.saveTokens(
      access: data['access'] as String,
      refresh: data['refresh'] as String,
    );
    final userData = data['user'] as Map<String, dynamic>;
    return User.fromJson(userData);
  }

  /// Register a new user account. Saves JWT tokens and returns the User.
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final data = await _api.post(
      '/auth/register/',
      {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
      auth: false,
    );
    await _tokenService.saveTokens(
      access: data['access'] as String,
      refresh: data['refresh'] as String,
    );
    final userData = data['user'] as Map<String, dynamic>;
    return User.fromJson(userData);
  }

  /// Returns the current user profile from the backend (used at app start).
  Future<User?> getProfile() async {
    try {
      final data = await _api.get('/auth/profile/');
      return User.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      // Token is invalid or expired
      await _tokenService.clearTokens();
      return null;
    }
  }

  /// Sends a password reset e-mail.
  Future<void> sendPasswordResetEmail(String email) async {
    await _api.post('/auth/password-reset/', {'email': email}, auth: false);
  }

  /// Logs the user out, clearing local tokens.
  Future<void> logout() async {
    try {
      final refresh = await _tokenService.readRefreshToken();
      if (refresh != null) {
        await _api.post('/auth/logout/', {'refresh': refresh});
      }
    } catch (_) {
      // Ignore logout errors – always clear local tokens.
    } finally {
      await _tokenService.clearTokens();
    }
  }
}
