// R9: sealed class с тремя подтипами, рендерится exhaustive switch
sealed class Countdown {
  const Countdown();

  factory Countdown.fromNow(DateTime when, Duration sessionLength) {
    final now = DateTime.now();
    if (now.isBefore(when)) {
      return Upcoming(when.difference(now));
    }
    final end = when.add(sessionLength);
    if (now.isBefore(end)) {
      return Started(now.difference(when));
    }
    return const Ended();
  }
}

class Upcoming extends Countdown {
  final Duration remaining;
  const Upcoming(this.remaining);
}

class Started extends Countdown {
  final Duration elapsed;
  const Started(this.elapsed);
}

class Ended extends Countdown {
  const Ended();
}

// Используй так в UI:
// String describe(Countdown c) => switch (c) {
//   Upcoming(remaining: var r) => 'Starts in ${r.inMinutes} min',
//   Started(elapsed: var e) => 'Started ${e.inMinutes} min ago',
//   Ended() => 'Ended',
// };
