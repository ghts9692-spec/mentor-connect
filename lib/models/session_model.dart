class Session {
  final String id;
  final String mentorId;
  final String mentorName;
  final String mentorExpertise;
  final String menteeId;
  final String topic;
  final String duration; // e.g. '30 min' or '60 min'
  final DateTime dateTime;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final double hourlyRate;

  const Session({
    required this.id,
    required this.mentorId,
    required this.mentorName,
    required this.mentorExpertise,
    required this.menteeId,
    required this.topic,
    required this.duration,
    required this.dateTime,
    this.status = 'upcoming',
    this.hourlyRate = 0,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id']?.toString() ?? '',
      mentorId: json['mentor_id']?.toString() ?? json['mentorId']?.toString() ?? '',
      mentorName: json['mentor_name'] as String? ?? json['mentorName'] as String? ?? '',
      mentorExpertise: json['mentor_expertise'] as String? ?? json['mentorExpertise'] as String? ?? '',
      menteeId: json['mentee_id']?.toString() ?? json['menteeId']?.toString() ?? '',
      topic: json['topic'] as String? ?? '',
      duration: json['duration'] as String? ?? '60 min',
      dateTime: json['date_time'] != null
          ? DateTime.parse(json['date_time'] as String)
          : json['dateTime'] != null
              ? DateTime.parse(json['dateTime'] as String)
              : DateTime.now(),
      status: json['status'] as String? ?? 'upcoming',
      hourlyRate: (json['hourly_rate'] ?? json['hourlyRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mentor_id': mentorId,
      'mentor_name': mentorName,
      'mentor_expertise': mentorExpertise,
      'mentee_id': menteeId,
      'topic': topic,
      'duration': duration,
      'date_time': dateTime.toIso8601String(),
      'status': status,
      'hourly_rate': hourlyRate,
    };
  }

  Session copyWith({String? status}) {
    return Session(
      id: id,
      mentorId: mentorId,
      mentorName: mentorName,
      mentorExpertise: mentorExpertise,
      menteeId: menteeId,
      topic: topic,
      duration: duration,
      dateTime: dateTime,
      status: status ?? this.status,
      hourlyRate: hourlyRate,
    );
  }
}
