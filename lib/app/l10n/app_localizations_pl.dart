// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get name_and_surname => 'Imię i nazwisko';

  @override
  String get birth_death_dates => 'XX.XX.XXXX - XX.XX.XXXX';

  @override
  String get mark_as_visited => 'Oznacz jako odwiedzony';

  @override
  String get mark_as_visited_semantic_label => 'Odznacz grób jako odwiedzony';

  @override
  String get navigate => 'Nawigacja';

  @override
  String get navigate_semantic_label => 'Nawiguj do celu';

  @override
  String get issue_fix => 'Zgłoś poprawkę';

  @override
  String get profile => 'Profil';

  @override
  String get profile_semantic_label => 'Profil użytkownika';

  @override
  String get suggest_fix => 'Zgłoś poprawkę';

  @override
  String get suggest_fix_semantic_label => 'Zgłoś poprawkę dotyczącą informacji o grobie';

  @override
  String get image_carousel_semantic_label => 'Zgłoś poprawkę dotyczącą informacji o grobie';

  @override
  String get loading_error => 'Nie udało się wczytać danych';

  @override
  String get graves_nearby => 'Groby w pobliżu';

  @override
  String get no_graves_found => 'Nie znaleziono żadnych grobów';

  @override
  String get back_to_list => 'Wróć do listy grobów';

  @override
  String get search_graves_hint => 'Szukaj';

  @override
  String get clear_search => 'Wyczyść wyszukiwanie';
}
