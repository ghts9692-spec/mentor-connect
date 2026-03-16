import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mentor_model.dart';
import '../services/mentor_service.dart';

export '../services/mentor_service.dart' show mentorServiceProvider;

// Parameters for mentor search
class MentorSearchParams {
  final String query;
  final String category;
  final double? minRating;
  final double? maxHourlyRate;
  final bool availableOnly;

  const MentorSearchParams({
    this.query = '',
    this.category = 'All',
    this.minRating,
    this.maxHourlyRate,
    this.availableOnly = false,
  });

  @override
  bool operator ==(Object other) =>
      other is MentorSearchParams &&
      other.query == query &&
      other.category == category &&
      other.minRating == minRating &&
      other.maxHourlyRate == maxHourlyRate &&
      other.availableOnly == availableOnly;

  @override
  int get hashCode => Object.hash(
        query,
        category,
        minRating,
        maxHourlyRate,
        availableOnly,
      );
}

final mentorSearchProvider =
    FutureProvider.autoDispose.family<List<Mentor>, MentorSearchParams>(
  (ref, params) => ref.read(mentorServiceProvider).searchMentors(
        query: params.query,
        category: params.category,
        minRating: params.minRating,
        maxHourlyRate: params.maxHourlyRate,
        availableOnly: params.availableOnly,
      ),
);

final mentorProfileProvider =
    FutureProvider.autoDispose.family<Mentor, String>(
  (ref, id) => ref.read(mentorServiceProvider).getMentorProfile(id),
);
