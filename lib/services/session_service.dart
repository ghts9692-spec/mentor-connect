import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_model.dart';
import 'api_service.dart';

final sessionServiceProvider = Provider(
  (ref) => SessionService(ref.read(apiServiceProvider)),
);

class SessionService {
  final ApiService _api;
  SessionService(this._api);

  /// Book a new session. Returns the confirmed Session with a real id.
  Future<Session> bookSession(Session session) async {
    final data = await _api.post('/sessions/create/', session.toJson());
    return Session.fromJson(data as Map<String, dynamic>);
  }

  /// Fetch all sessions for the current user.
  Future<List<Session>> getMySessions() async {
    final data = await _api.get('/sessions/my/');
    final list = data as List<dynamic>;
    return list
        .map((e) => Session.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Cancel an existing session by id.
  Future<void> cancelSession(String sessionId) async {
    await _api.patch('/sessions/$sessionId/cancel/', {});
  }
}
