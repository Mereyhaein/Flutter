# movie_club

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Movie Club

Flutter-приложение для киноклуба в университете: студенты видят список
предстоящих киносеансов, могут забронировать место, добавлять сеансы в
избранное и редактировать свой профиль (имя, группа, тема приложения).

## Домен

**Movie Club** (кинопоказы) — приложение организует внутриуниверситетские
киносеансы. Каждый сеанс (`Screening`) имеет название, жанр, дату и время,
место проведения (зал или онлайн-ссылку), лимит мест и список
записавшихся. Пользователь (`Profile`) может просматривать список
сеансов, фильтровать их по жанру и статусу (прошедшие/предстоящие),
искать по названию, бронировать или отменять бронь, отмечать сеансы как
избранные, а также редактировать свой профиль и менять тему приложения.

## Скриншоты

| Светлая тема | Тёмная тема | Грид (планшет) |
|---|---|---|
| ![Light theme](docs/screenshots/list_light.png) | ![Dark theme](docs/screenshots/list_dark.png) | ![Grid tablet](docs/screenshots/grid_tablet.png) |

## Decisions

Список сеансов (`List<Screening>`) и профиль пользователя хранятся в
`State` виджета `AppShell`, а не в отдельных экранах — это единственный
общий источник правды, и все три вкладки (список, избранное, профиль)
читают одни и те же данные. Экран деталей получает данные и колбэки
(`onUpdate`, `onDelete`) сверху, потому что он не владеет состоянием —
он просит родителя что-то изменить. Экран формы, наоборот, не знает про
остальной список: он просто собирает новый/изменённый `Screening` и
возвращает его через `Navigator.pop(context, result)`, а вызывающий код
(`ListScreen`/`DetailScreen`) сам решает, что с ним делать. Сетка на
`GridView`/`ListView` переключается через `LayoutBuilder`, а не
`MediaQuery`, потому что `LayoutBuilder` даёт ширину именно того
контейнера, в котором строится список, а не всего экрана — это правильно
работает и внутри вкладок, и при разделении экрана. Диалог `PopScope`
сравнивает текущие значения полей формы (`title`, `genre`, `when`,
`venue`, `limit`, …) с их исходными значениями при открытии формы
(`_isDirty`), и отдельно использует флаг `_savedSuccessfully`, чтобы не
показывать «Discard changes?» сразу после успешного сохранения — иначе
`pop` после `Save` сам попадал бы под перехват диалога. С инструментами
9-й недели (Provider/Riverpod) я бы вынесла список сеансов и профиль в
отдельный провайдер вместо ручной передачи колбэков через конструкторы
на 3-4 уровня вниз — это убрало бы «callback hell» в `AppShell` и
сделало бы код короче.

## Запуск

```bash
flutter pub get
flutter run
```