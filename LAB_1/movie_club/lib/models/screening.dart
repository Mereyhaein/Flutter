import 'movie_genre.dart';

// R1: immutable модель
class Screening {
  static int _counter = 0;
  final String id;
  final String title;
  final MovieGenre genre;
  final DateTime when;
  final String venue;
  final int limit;
  final List<String> _attendees;
  final bool isOnline;
  final String? description;
  final bool favourite;
  final String imageAsset;

  Screening({
    String? id,
    required this.title,
    required this.genre,
    required this.when,
    required this.venue,
    required this.limit,
    List<String> attendees = const [],
    this.isOnline = false,
    this.description,
    this.favourite = false,
    this.imageAsset = 'assets/images/placeholder.jpg',
  }) : id = id ?? '${DateTime.now().microsecondsSinceEpoch}_${_counter++}',
       _attendees = List.unmodifiable(attendees);

  factory Screening.empty() => Screening(
    title: '',
    genre: MovieGenre.action,
    when: DateTime.now().add(const Duration(days: 1)),
    venue: '',
    limit: 1,
  );

  List<String> get attendees => _attendees;
  int get count => _attendees.length;
  bool get isFull => count >= limit;
  bool get isPast => when.isBefore(DateTime.now());
  bool contains(String name) => _attendees.any((n) => n == name);

  ({int taken, int free}) get places =>
      (taken: count, free: (limit - count).clamp(0, limit));

  Screening copyWith({
    String? title,
    MovieGenre? genre,
    DateTime? when,
    String? venue,
    int? limit,
    List<String>? attendees,
    bool? isOnline,
    String? description,
    bool? favourite,
    String? imageAsset,
  }) {
    return Screening(
      id: id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      when: when ?? this.when,
      venue: venue ?? this.venue,
      limit: limit ?? this.limit,
      attendees: attendees ?? _attendees,
      isOnline: isOnline ?? this.isOnline,
      description: description ?? this.description,
      favourite: favourite ?? this.favourite,
      imageAsset: imageAsset ?? this.imageAsset,
    );
  }
}
