import 'movie_genre.dart';
import 'screening.dart';

final List<Screening> seedScreenings = [
  Screening(
    title: 'Dune: Part Three',
    genre: MovieGenre.action,
    when: DateTime.now().add(const Duration(days: 3, hours: 2)),
    venue: 'Hall 1',
    limit: 40,
    attendees: ['Aigerim', 'Nurlan', 'Dias'],
    description: 'Final chapter of the saga on the big screen.',
    imageAsset: 'assets/images/dune.jpg',
  ),

  Screening(
    title: 'The Greatest Documentary About Mountains You Will Ever See Period',
    genre: MovieGenre.documentary,
    when: DateTime.now().add(const Duration(days: 5)),
    venue: 'Hall 3',
    limit: 25,
    attendees: ['Madina'],
    description: 'Shot over three years in the Tian Shan range.',
    imageAsset: 'assets/images/mountains_doc.jpg',
  ),

  Screening(
    title: 'Midnight Comedy Night',
    genre: MovieGenre.comedy,
    when: DateTime.now().add(const Duration(days: 1, hours: 20)),
    venue: 'Hall 2',
    limit: 3,
    attendees: ['Yerlan', 'Saule', 'Timur'],
    description: 'Stand-up warmup before the main feature.',
    imageAsset: 'assets/images/midnight_comedy.jpg',
  ),

  Screening(
    title: 'Classic Horror Marathon',
    genre: MovieGenre.horror,
    when: DateTime.now().subtract(const Duration(days: 4)),
    venue: 'Hall 1',
    limit: 50,
    attendees: ['Alisher', 'Zarina'],
    description: 'Three vintage horror films back to back.',
    imageAsset: 'assets/images/horror_marathon.jpg',
  ),

  Screening(
    title: 'Online Premiere: Silent Streets',
    genre: MovieGenre.drama,
    when: DateTime.now().add(const Duration(days: 2, hours: 10)),
    venue: 'https://stream.movieclub.example/silent-streets',
    limit: 200,
    attendees: ['Bota', 'Erlan', 'Kamila', 'Dana'],
    isOnline: true,
    description: 'Worldwide online premiere with live Q&A.',
    imageAsset: 'assets/images/silent_streets.jpg',
  ),

  Screening(
    title: 'Action Night: Reload',
    genre: MovieGenre.action,
    when: DateTime.now().add(const Duration(days: 6, hours: 1)),
    venue: 'Hall 4',
    limit: 60,
    attendees: ['Olzhas'],
    imageAsset: 'assets/images/action_reload.jpg',
  ),

  Screening(
    title: 'Documentary Shorts Vol. 2',
    genre: MovieGenre.documentary,
    when: DateTime.now().add(const Duration(days: 8, hours: 3)),
    venue: 'Hall 2',
    limit: 30,
    attendees: ['Aruzhan', 'Nurbol', 'Saida'],
    description: 'A curated set of award-winning short docs.',
    imageAsset: 'assets/images/doc_shorts.jpg',
  ),

  Screening(
    title: 'Comedy Classics Rewind',
    genre: MovieGenre.comedy,
    when: DateTime.now().add(const Duration(days: 9)),
    venue: 'Hall 1',
    limit: 45,
    attendees: ['Askar', 'Gulnaz'],
    description: 'Three decades of comedy, one evening.',
    imageAsset: 'assets/images/comedy_classics.jpg',
  ),

  Screening(
    title: 'Drama Under the Stars',
    genre: MovieGenre.drama,
    when: DateTime.now().add(const Duration(days: 10, hours: 4)),
    venue: 'Open-air Court',
    limit: 80,
    attendees: ['Yerbolat', 'Aidana', 'Ruslan', 'Inkar'],
    description: 'Outdoor screening, bring your own blanket.',
    imageAsset: 'assets/images/drama_stars.jpg',
  ),

  Screening(
    title: 'Horror Shorts Late Show',
    genre: MovieGenre.horror,
    when: DateTime.now().add(const Duration(days: 1, hours: 2)),
    venue: 'Hall 3',
    limit: 20,
    attendees: ['Alina'],
    description: 'Not for the faint of heart.',
    imageAsset: 'assets/images/horror_shorts.jpg',
  ),

  Screening(
    title: 'Online Watch Party: City Lights Reborn',
    genre: MovieGenre.drama,
    when: DateTime.now().add(const Duration(days: 4, hours: 6)),
    venue: 'https://stream.movieclub.example/city-lights',
    limit: 150,
    attendees: ['Daulet', 'Aidos'],
    isOnline: true,
    description: 'Restored classic, streamed live with commentary.',
    imageAsset: 'assets/images/city_lights.jpg',
  ),

  Screening(
    title: 'Action Finale Weekend',
    genre: MovieGenre.action,
    when: DateTime.now().subtract(const Duration(days: 1)),
    venue: 'Hall 1',
    limit: 70,
    attendees: ['Zhanel', 'Marat', 'Saken'],
    description: 'Closing weekend of the action retrospective.',
    imageAsset: 'assets/images/action_finale.jpg',
  ),
];
