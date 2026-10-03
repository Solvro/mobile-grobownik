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
  String get current_location => 'Moja lokalizacja';

  @override
  String get current_location_semantic_label => 'Wyśrodkuj mapę na mojej lokalizacji';

  @override
  String get location_service_disabled => 'Usługi lokalizacji są wyłączone';

  @override
  String get location_permission_blocked => 'Dostęp do lokalizacji jest zablokowany';

  @override
  String get location_permission_denied => 'Bez zgody na lokalizację nie pokażemy Twojej pozycji';

  @override
  String get location_unavailable => 'Nie udało się pobrać lokalizacji';

  @override
  String get open_settings => 'Ustawienia';

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

  @override
  String get grave_photo_semantic_label => 'Zdjęcie grobu';

  @override
  String get no_grave_photo_semantic_label => 'Brak zdjęcia grobu';

  @override
  String get settings => 'Ustawienia';

  @override
  String get settings_semantic_label => 'Otwórz ustawienia aplikacji';

  @override
  String get settings_appearance => 'Wygląd';

  @override
  String get settings_dark_mode => 'Tryb ciemny';

  @override
  String get settings_dark_mode_subtitle => 'Przełącz między jasnym a ciemnym motywem';

  @override
  String get settings_about => 'O aplikacji';

  @override
  String get settings_app_info => 'Informacje o aplikacji';

  @override
  String get settings_licenses => 'Licencje';

  @override
  String get settings_licenses_subtitle => 'Biblioteki open source użyte w aplikacji';

  @override
  String get settings_app_legalese => '© KN Solvro. Aplikacja Grobownik.';

  @override
  String settings_version(String version, String buildNumber) {
    return 'Wersja $version ($buildNumber)';
  }

  @override
  String get settings_version_unknown => 'Nieznana wersja';

  @override
  String get settings_team => 'Zespół';

  @override
  String get settings_team_subtitle => 'Poznaj twórców aplikacji';

  @override
  String get settings_team_members => 'Skład';

  @override
  String get settings_team_links => 'Linki';

  @override
  String get settings_team_website => 'Strona Solvro';

  @override
  String get settings_team_github => 'Repozytorium GitHub';

  @override
  String get logout => 'Wyloguj';

  @override
  String stats_loading_error(String err) {
    return 'Błąd ładowania statystyk:\n$err';
  }

  @override
  String get error_title => 'Błąd';

  @override
  String get action_retry => 'Spróbuj ponownie';

  @override
  String get location_city => 'Miasto';

  @override
  String get stats_total_graves_visited => 'Łącznie odwiedzonych grobów';

  @override
  String get visit_history => 'Historia wizyt';

  @override
  String get visits_empty => 'Brak zarejestrowanych wizyt.';

  @override
  String get visit_date_unknown => 'Nieznana data';

  @override
  String get location_place => 'Miejsce';

  @override
  String visit_grave_id(String graveId) {
    return 'ID grobu: $graveId';
  }

  @override
  String visit_location_coords(String latitude, String longitude) {
    return 'Lokalizacja: $latitude, $longitude';
  }

  @override
  String get login_failed => 'Logowanie nie powiodło się. Sprawdź login i hasło.';

  @override
  String get login => 'Zaloguj';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Hasło';
}
