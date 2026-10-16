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
  String get sync_in_progress => 'Synchronizacja…';

  @override
  String sync_synced_at(String time) {
    return 'Zsynchronizowano: $time';
  }

  @override
  String sync_data_from(String time) {
    return 'Dane z: $time';
  }

  @override
  String sync_offline_with_data(String time) {
    return 'Brak połączenia. Dane z: $time';
  }

  @override
  String get sync_offline_no_data => 'Brak połączenia. Brak zapisanych danych';

  @override
  String sync_failed_with_data(String time) {
    return 'Błąd synchronizacji. Dane z: $time';
  }

  @override
  String get sync_failed_no_data => 'Błąd synchronizacji. Brak zapisanych danych';

  @override
  String get sync_refresh => 'Odśwież dane';

  @override
  String get sync_refresh_semantic_label => 'Odśwież listę grobów z serwera';

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

  @override
  String get grave_tab_directions => 'Wskazówki dojścia';

  @override
  String get grave_tab_biography => 'Życiorys';

  @override
  String get grave_biography_title => 'Życiorys';

  @override
  String get grave_biography_empty => 'Brak życiorysu';

  @override
  String get grave_cemetery => 'Cmentarz';

  @override
  String get grave_plot => 'Kwatera';

  @override
  String get grave_directions => 'Jak dojść';

  @override
  String get grave_location_precision_grave => 'Dokładne miejsce grobu';

  @override
  String get grave_location_precision_field => 'Przybliżona lokalizacja – środek kwatery';

  @override
  String get grave_location_precision_unknown => 'Dokładność lokalizacji nieznana';

  @override
  String get grave_location_missing => 'Lokalizacja grobu nie jest jeszcze znana';

  @override
  String get grave_no_location_details => 'Brak dodatkowych informacji o położeniu grobu';

  @override
  String grave_location_source_open(String source) {
    return 'Źródło: $source';
  }

  @override
  String grave_location_source_label(String source) {
    return 'Źródło lokalizacji: $source';
  }

  @override
  String get location_source_grobonet => 'Grobonet';

  @override
  String get location_source_mogily => 'mogily.pl';

  @override
  String get location_source_cui => 'Wyszukiwarka grobów CUI Wrocław';

  @override
  String get location_source_spreadsheet => 'Wykaz Politechniki Wrocławskiej';

  @override
  String get location_source_other => 'Inne źródło';

  @override
  String get grave_education => 'Wykształcenie';

  @override
  String get grave_subjects => 'Przedmioty';

  @override
  String get grave_achievements => 'Osiągnięcia';

  @override
  String get grave_notes => 'Notatki';

  @override
  String get grave_coordinates => 'Współrzędne';

  @override
  String grave_distance_from_you(String distance) {
    return '$distance od Ciebie';
  }

  @override
  String get location_source_volunteer => 'Pomiar wolontariusza w terenie';

  @override
  String get action_open_link => 'Otwórz link';

  @override
  String get auth_status_in_progress => 'logowanie…';

  @override
  String get auth_status_logged_in => 'zalogowano';

  @override
  String get auth_status_failed => 'logowanie nie powiodło się';

  @override
  String get auth_status_offline => 'brak połączenia, zalogujemy po jego odzyskaniu';

  @override
  String get login_offline => 'Brak połączenia z serwerem. Spróbuj ponownie, gdy wróci internet.';

  @override
  String get visit_marked => 'Odwiedzono';

  @override
  String get visit_saved => 'Zapisano wizytę';

  @override
  String get visit_save_failed => 'Nie udało się zapisać wizyty. Spróbuj ponownie.';

  @override
  String get visit_offline => 'Brak połączenia – nie można teraz zapisać wizyty.';

  @override
  String get visit_login_in_progress => 'Trwa logowanie, spróbuj za chwilę.';

  @override
  String get visit_no_location =>
      'Nie znamy Twojej lokalizacji. Włącz GPS i zezwól aplikacji na dostęp do lokalizacji.';

  @override
  String visit_too_far(String distance, String limit) {
    return 'Jesteś za daleko od grobu ($distance). Podejdź bliżej – do $limit.';
  }

  @override
  String grave_visits_summary(String count, String date) {
    return 'Twoje wizyty: $count · ostatnio $date';
  }

  @override
  String get grave_visits_none => 'Nie masz jeszcze wizyt przy tym grobie';

  @override
  String get grave_tab_my_visits => 'Moje wizyty';

  @override
  String get grave_visits_login_prompt => 'Zaloguj się, aby zapisywać wizyty i widzieć ich historię.';

  @override
  String get grave_visits_unavailable => 'Historia wizyt będzie dostępna po zalogowaniu.';

  @override
  String get grave_visits_error => 'Nie udało się pobrać historii wizyt.';

  @override
  String get visit_again_today_title => 'Dzisiejsza wizyta jest już zapisana';

  @override
  String visit_again_today_body(String time) {
    return 'Masz już zapisaną dzisiejszą wizytę przy tym grobie (o $time). Czy na pewno chcesz zapisać kolejną?';
  }

  @override
  String get visit_again_today_confirm => 'Zapisz kolejną';

  @override
  String get action_cancel => 'Anuluj';
}
