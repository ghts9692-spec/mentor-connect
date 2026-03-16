class Mentor {
  final String id;
  final String name;
  final String expertise;
  final String title;
  final String location;
  final String about;
  final double rating;
  final int reviews;
  final int sessions;
  final int experienceYears;
  final double hourlyRate;
  final bool isAvailable;
  final List<String> skills;

  const Mentor({
    required this.id,
    required this.name,
    required this.expertise,
    this.title = '',
    this.location = '',
    this.about = '',
    this.rating = 0.0,
    this.reviews = 0,
    this.sessions = 0,
    this.experienceYears = 0,
    this.hourlyRate = 0,
    this.isAvailable = true,
    this.skills = const [],
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      expertise: json['expertise'] as String? ?? '',
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      about: json['about'] as String? ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: (json['reviews'] ?? 0) as int,
      sessions: (json['sessions'] ?? 0) as int,
      experienceYears: (json['experience_years'] ?? json['experienceYears'] ?? 0) as int,
      hourlyRate: (json['hourly_rate'] ?? json['hourlyRate'] ?? 0).toDouble(),
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
      skills: List<String>.from(json['skills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'expertise': expertise,
      'title': title,
      'location': location,
      'about': about,
      'rating': rating,
      'reviews': reviews,
      'sessions': sessions,
      'experience_years': experienceYears,
      'hourly_rate': hourlyRate,
      'is_available': isAvailable,
      'skills': skills,
    };
  }

  /// Sample mentors – used as fallback / for development when backend is unavailable.
  static const List<Mentor> sampleMentors = [
    Mentor(
      id: '1',
      name: 'Sarah Jenkins',
      expertise: 'Product Design',
      title: 'Senior Product Designer at Google',
      location: 'San Francisco, CA',
      about:
          'Passionate product designer with 5+ years of experience at top tech companies.',
      rating: 4.9,
      reviews: 42,
      sessions: 156,
      experienceYears: 5,
      hourlyRate: 50,
      skills: ['Product Design', 'UX Research', 'Design Systems', 'Prototyping'],
    ),
    Mentor(
      id: '2',
      name: 'David Chen',
      expertise: 'Engineering',
      title: 'Staff Engineer at Meta',
      location: 'New York, NY',
      about: 'Full-stack engineer specializing in scalable systems.',
      rating: 4.8,
      reviews: 31,
      sessions: 120,
      experienceYears: 8,
      hourlyRate: 60,
      skills: ['System Design', 'Flutter', 'React', 'Cloud Architecture'],
    ),
    Mentor(
      id: '3',
      name: 'Emily Watson',
      expertise: 'Marketing',
      title: 'VP of Marketing at Spotify',
      location: 'London, UK',
      about: 'Growth marketing expert with a passion for data-driven strategies.',
      rating: 4.7,
      reviews: 18,
      sessions: 80,
      experienceYears: 6,
      hourlyRate: 45,
      skills: ['Growth Marketing', 'Brand Strategy', 'Analytics', 'SEO'],
    ),
    Mentor(
      id: '4',
      name: 'Alex Rivera',
      expertise: 'UX Design',
      title: 'UX Lead at Airbnb',
      location: 'Austin, TX',
      about: 'Design leader focused on accessibility and inclusive design.',
      rating: 4.8,
      reviews: 24,
      sessions: 95,
      experienceYears: 4,
      hourlyRate: 55,
      skills: ['UX Design', 'Accessibility', 'Figma', 'Interaction Design'],
    ),
    Mentor(
      id: '5',
      name: 'Michael Kim',
      expertise: 'Data Science',
      title: 'Principal Data Scientist at Netflix',
      location: 'Seattle, WA',
      about: 'ML engineer helping aspiring data scientists break into the field.',
      rating: 4.9,
      reviews: 56,
      sessions: 200,
      experienceYears: 7,
      hourlyRate: 70,
      skills: ['Machine Learning', 'Python', 'Statistics', 'Deep Learning'],
    ),
    Mentor(
      id: '6',
      name: 'Lisa Thompson',
      expertise: 'Leadership',
      title: 'Engineering Director at Amazon',
      location: 'Chicago, IL',
      about: 'Engineering leader passionate about growing future tech leaders.',
      rating: 4.6,
      reviews: 22,
      sessions: 110,
      experienceYears: 10,
      hourlyRate: 80,
      skills: ['Team Building', 'Strategic Planning', 'Coaching'],
    ),
  ];
}
