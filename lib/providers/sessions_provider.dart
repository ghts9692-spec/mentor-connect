import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_model.dart';
import '../providers/user_provider.dart';
import '../services/session_service.dart';

export '../services/session_service.dart' show sessionServiceProvider;

final sessionsProvider = FutureProvider.autoDispose<List<Session>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return [];
  return ref.read(sessionServiceProvider).getMySessions();
});
