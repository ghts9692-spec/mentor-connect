import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mentor_model.dart';
import 'api_service.dart';

final mentorServiceProvider = Provider(
  (ref) => MentorService(ref.read(apiServiceProvider)),
);

class MentorService {
  final ApiService _api;
  MentorService(this._api);

  /// Search mentors with optional filters. All params are optional.
  Future<List<Mentor>> searchMentors({
    String? query,
    String? category,
    double? minRating,
    double? maxHourlyRate,
    bool? availableOnly,
  }) async {
    final params = <String, String>{};
    if (query != null && query.isNotEmpty) params['search'] = query;
    if (category != null && category != 'All') params['expertise'] = category;
    if (minRating != null) params['min_rating'] = minRating.toString();
    if (maxHourlyRate != null) params['max_rate'] = maxHourlyRate.toString();
    if (availableOnly == true) params['available'] = 'true';

    final queryString = params.isNotEmpty
        ? '?${params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final data = await _api.get('/mentors/search/$queryString');
    final list = data as List<dynamic>;
    return list.map((e) => Mentor.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get a single mentor profile by id.
  Future<Mentor> getMentorProfile(String id) async {
    final data = await _api.get('/mentors/$id/');
    return Mentor.fromJson(data as Map<String, dynamic>);
  }
}
