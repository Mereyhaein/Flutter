
# Practice 10 — The Data Arrives Later

## Level 1 — Event Order

Predicted:
A, C, first app frame, B, 6 students.

Actual:
[Add actual console output.]

## Level 2 — Four States

Implemented:
- Loading
- Error
- Empty
- Data

Expected error without mounted:
setState() called after dispose()

Actual:
[Add the real error from the console.]

## Level 3 — FutureBuilder

The Future is stored in a field.

Changing the Compact switch does not create
another Future.

Actual:
[Add fetchStudents console logs.]

## Level 4 — Countdown

Version A uses StreamBuilder.
Version B uses StreamSubscription.

With cancel():
[Add actual observation.]

Without cancel():
[Add actual observation.]

## Level 5 — Save

Save uses await and try/on StateError.

Expected unsafe error:
Unhandled Exception: Bad state: server rejected 6

Actual:
[Add the real console error.]

## Screenshots

- screenshot_error.png
- screenshot_countdown.png

## Final Checks

- [ ] dart format .
- [ ] flutter analyze
- [ ] Screenshots
- [ ] NOTES.md completed
- [ ] GitHub push
