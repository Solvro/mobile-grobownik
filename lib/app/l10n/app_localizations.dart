import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pl')];

  /// Placeholder for name and surname
  ///
  /// In pl, this message translates to:
  /// **'Imię i nazwisko'**
  String get name_and_surname;

  /// Placeholder for birth and death dates
  ///
  /// In pl, this message translates to:
  /// **'XX.XX.XXXX - XX.XX.XXXX'**
  String get birth_death_dates;

  /// Button for marking a grave as visited
  ///
  /// In pl, this message translates to:
  /// **'Oznacz jako odwiedzony'**
  String get mark_as_visited;

  /// Semantic label for button for marking a grave as visited
  ///
  /// In pl, this message translates to:
  /// **'Odznacz grób jako odwiedzony'**
  String get mark_as_visited_semantic_label;

  /// Button for navigation
  ///
  /// In pl, this message translates to:
  /// **'Nawigacja'**
  String get navigate;

  /// Semantic label for button for navigation
  ///
  /// In pl, this message translates to:
  /// **'Nawiguj do celu'**
  String get navigate_semantic_label;

  /// Button for issuing a fix regarding grave information
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś poprawkę'**
  String get issue_fix;

  /// Text for button and title of Profile screen
  ///
  /// In pl, this message translates to:
  /// **'Profil'**
  String get profile;

  /// Semantic label for profile button
  ///
  /// In pl, this message translates to:
  /// **'Profil użytkownika'**
  String get profile_semantic_label;

  /// Button for fix issue
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś poprawkę'**
  String get suggest_fix;

  /// Semantic label for fix issue button
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś poprawkę dotyczącą informacji o grobie'**
  String get suggest_fix_semantic_label;

  /// Semantic label for image caroudel images
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś poprawkę dotyczącą informacji o grobie'**
  String get image_carousel_semantic_label;

  /// Tooltip for the button centering the map on the user's location
  ///
  /// In pl, this message translates to:
  /// **'Moja lokalizacja'**
  String get current_location;

  /// Semantic label for the button centering the map on the user's location
  ///
  /// In pl, this message translates to:
  /// **'Wyśrodkuj mapę na mojej lokalizacji'**
  String get current_location_semantic_label;

  /// Shown when location services are turned off device-wide
  ///
  /// In pl, this message translates to:
  /// **'Usługi lokalizacji są wyłączone'**
  String get location_service_disabled;

  /// Shown when the location permission was denied permanently
  ///
  /// In pl, this message translates to:
  /// **'Dostęp do lokalizacji jest zablokowany'**
  String get location_permission_blocked;

  /// Shown when the user refused the location permission
  ///
  /// In pl, this message translates to:
  /// **'Bez zgody na lokalizację nie pokażemy Twojej pozycji'**
  String get location_permission_denied;

  /// Shown when reading the device location failed
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać lokalizacji'**
  String get location_unavailable;

  /// Snack bar action opening the system settings screen
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get open_settings;

  /// Shown when grave details could not be fetched
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się wczytać danych'**
  String get loading_error;

  /// Title of the list of nearby graves shown in the bottom sheet
  ///
  /// In pl, this message translates to:
  /// **'Groby w pobliżu'**
  String get graves_nearby;

  /// Shown when the list of graves is empty
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono żadnych grobów'**
  String get no_graves_found;

  /// Tooltip/semantic label for the back arrow that returns from grave details to the list
  ///
  /// In pl, this message translates to:
  /// **'Wróć do listy grobów'**
  String get back_to_list;

  /// Placeholder text in the graves search bar
  ///
  /// In pl, this message translates to:
  /// **'Szukaj'**
  String get search_graves_hint;

  /// Tooltip for the button that clears the graves search bar
  ///
  /// In pl, this message translates to:
  /// **'Wyczyść wyszukiwanie'**
  String get clear_search;

  /// Semantic label for the grave thumbnail in the list of graves
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcie grobu'**
  String get grave_photo_semantic_label;

  /// Semantic label for the placeholder shown when a grave has no photo
  ///
  /// In pl, this message translates to:
  /// **'Brak zdjęcia grobu'**
  String get no_grave_photo_semantic_label;

  /// Title of the settings screen
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settings;

  /// Semantic label for the settings button
  ///
  /// In pl, this message translates to:
  /// **'Otwórz ustawienia aplikacji'**
  String get settings_semantic_label;

  /// Section header for appearance settings
  ///
  /// In pl, this message translates to:
  /// **'Wygląd'**
  String get settings_appearance;

  /// Label for the dark mode toggle
  ///
  /// In pl, this message translates to:
  /// **'Tryb ciemny'**
  String get settings_dark_mode;

  /// Subtitle explaining the dark mode toggle
  ///
  /// In pl, this message translates to:
  /// **'Przełącz między jasnym a ciemnym motywem'**
  String get settings_dark_mode_subtitle;

  /// Section header for about / app info settings
  ///
  /// In pl, this message translates to:
  /// **'O aplikacji'**
  String get settings_about;

  /// Label for the app info / version tile
  ///
  /// In pl, this message translates to:
  /// **'Informacje o aplikacji'**
  String get settings_app_info;

  /// Label for opening open-source licenses
  ///
  /// In pl, this message translates to:
  /// **'Licencje'**
  String get settings_licenses;

  /// Subtitle for the licenses tile
  ///
  /// In pl, this message translates to:
  /// **'Biblioteki open source użyte w aplikacji'**
  String get settings_licenses_subtitle;

  /// Short legalese shown on the licenses page
  ///
  /// In pl, this message translates to:
  /// **'© KN Solvro. Aplikacja Grobownik.'**
  String get settings_app_legalese;

  /// App version label with version and build number
  ///
  /// In pl, this message translates to:
  /// **'Wersja {version} ({buildNumber})'**
  String settings_version(String version, String buildNumber);

  /// Shown while app version is still loading
  ///
  /// In pl, this message translates to:
  /// **'Nieznana wersja'**
  String get settings_version_unknown;

  /// Label for the team info screen
  ///
  /// In pl, this message translates to:
  /// **'Zespół'**
  String get settings_team;

  /// Subtitle for the team info tile
  ///
  /// In pl, this message translates to:
  /// **'Poznaj twórców aplikacji'**
  String get settings_team_subtitle;

  /// Section header listing team members
  ///
  /// In pl, this message translates to:
  /// **'Skład'**
  String get settings_team_members;

  /// Section header for team-related external links
  ///
  /// In pl, this message translates to:
  /// **'Linki'**
  String get settings_team_links;

  /// Label for opening the Solvro website
  ///
  /// In pl, this message translates to:
  /// **'Strona Solvro'**
  String get settings_team_website;

  /// Label for opening the project GitHub repository
  ///
  /// In pl, this message translates to:
  /// **'Repozytorium GitHub'**
  String get settings_team_github;

  /// Shown above the list of graves while data is being downloaded
  ///
  /// In pl, this message translates to:
  /// **'Synchronizacja…'**
  String get sync_in_progress;

  /// Shown above the list of graves after a successful synchronization
  ///
  /// In pl, this message translates to:
  /// **'Zsynchronizowano: {time}'**
  String sync_synced_at(String time);

  /// Shown above the list of graves when no synchronization has run yet in this session
  ///
  /// In pl, this message translates to:
  /// **'Dane z: {time}'**
  String sync_data_from(String time);

  /// Shown when synchronization failed because there is no connection and older data is available
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia. Dane z: {time}'**
  String sync_offline_with_data(String time);

  /// Shown when synchronization failed because there is no connection and nothing is stored yet
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia. Brak zapisanych danych'**
  String get sync_offline_no_data;

  /// Shown when synchronization failed for a reason other than missing connection and older data is available
  ///
  /// In pl, this message translates to:
  /// **'Błąd synchronizacji. Dane z: {time}'**
  String sync_failed_with_data(String time);

  /// Shown when synchronization failed for a reason other than missing connection and nothing is stored yet
  ///
  /// In pl, this message translates to:
  /// **'Błąd synchronizacji. Brak zapisanych danych'**
  String get sync_failed_no_data;

  /// Tooltip for the button that starts a synchronization by hand
  ///
  /// In pl, this message translates to:
  /// **'Odśwież dane'**
  String get sync_refresh;

  /// Semantic label for the button that starts a synchronization by hand
  ///
  /// In pl, this message translates to:
  /// **'Odśwież listę grobów z serwera'**
  String get sync_refresh_semantic_label;

  /// label for logout
  ///
  /// In pl, this message translates to:
  /// **'Wyloguj'**
  String get logout;

  /// Error message shown when statistics fail to load
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania statystyk:\n{err}'**
  String stats_loading_error(String err);

  /// General error title
  ///
  /// In pl, this message translates to:
  /// **'Błąd'**
  String get error_title;

  /// Label for retry button
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get action_retry;

  /// Label for city location
  ///
  /// In pl, this message translates to:
  /// **'Miasto'**
  String get location_city;

  /// Label for total graves visited statistic
  ///
  /// In pl, this message translates to:
  /// **'Łącznie odwiedzonych grobów'**
  String get stats_total_graves_visited;

  /// Title for visit history screen
  ///
  /// In pl, this message translates to:
  /// **'Historia wizyt'**
  String get visit_history;

  /// Message shown when there are no visit records
  ///
  /// In pl, this message translates to:
  /// **'Brak zarejestrowanych wizyt.'**
  String get visits_empty;

  /// Fallback text when visit date is unknown
  ///
  /// In pl, this message translates to:
  /// **'Nieznana data'**
  String get visit_date_unknown;

  /// Label for place location
  ///
  /// In pl, this message translates to:
  /// **'Miejsce'**
  String get location_place;

  /// Label displaying the grave identifier for a visit
  ///
  /// In pl, this message translates to:
  /// **'ID grobu: {graveId}'**
  String visit_grave_id(String graveId);

  /// Coordinates displaying latitude and longitude for a visit location
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja: {latitude}, {longitude}'**
  String visit_location_coords(String latitude, String longitude);

  /// Error message for failed authentication
  ///
  /// In pl, this message translates to:
  /// **'Logowanie nie powiodło się. Sprawdź login i hasło.'**
  String get login_failed;

  /// Label for login
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj'**
  String get login;

  /// Label for email
  ///
  /// In pl, this message translates to:
  /// **'E-mail'**
  String get email;

  /// Label for password
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get password;

  /// Tab with location and directions in grave details
  ///
  /// In pl, this message translates to:
  /// **'Wskazówki dojścia'**
  String get grave_tab_directions;

  /// Tab with biography in grave details
  ///
  /// In pl, this message translates to:
  /// **'Życiorys'**
  String get grave_tab_biography;

  /// Title of the biography card
  ///
  /// In pl, this message translates to:
  /// **'Życiorys'**
  String get grave_biography_title;

  /// Shown when a grave has no biography
  ///
  /// In pl, this message translates to:
  /// **'Brak życiorysu'**
  String get grave_biography_empty;

  /// Label for the cemetery a grave is in
  ///
  /// In pl, this message translates to:
  /// **'Cmentarz'**
  String get grave_cemetery;

  /// Label for the field / row / grave number
  ///
  /// In pl, this message translates to:
  /// **'Kwatera'**
  String get grave_plot;

  /// Label for on-site hints on finding the grave
  ///
  /// In pl, this message translates to:
  /// **'Jak dojść'**
  String get grave_directions;

  /// Pin points at the grave itself
  ///
  /// In pl, this message translates to:
  /// **'Dokładne miejsce grobu'**
  String get grave_location_precision_grave;

  /// Pin points at the middle of the cemetery field, not the grave
  ///
  /// In pl, this message translates to:
  /// **'Przybliżona lokalizacja – środek kwatery'**
  String get grave_location_precision_field;

  /// Location precision is not known
  ///
  /// In pl, this message translates to:
  /// **'Dokładność lokalizacji nieznana'**
  String get grave_location_precision_unknown;

  /// Shown when a grave has no coordinates
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja grobu nie jest jeszcze znana'**
  String get grave_location_missing;

  /// Shown when a grave has no cemetery, plot or directions
  ///
  /// In pl, this message translates to:
  /// **'Brak dodatkowych informacji o położeniu grobu'**
  String get grave_no_location_details;

  /// Button opening the record the location was taken from
  ///
  /// In pl, this message translates to:
  /// **'Źródło: {source}'**
  String grave_location_source_open(String source);

  /// Location source without a link
  ///
  /// In pl, this message translates to:
  /// **'Źródło lokalizacji: {source}'**
  String grave_location_source_label(String source);

  /// Name of the grobonet.com source
  ///
  /// In pl, this message translates to:
  /// **'Grobonet'**
  String get location_source_grobonet;

  /// Name of the mogily.pl source
  ///
  /// In pl, this message translates to:
  /// **'mogily.pl'**
  String get location_source_mogily;

  /// Name of the groby.cui.wroclaw.pl source
  ///
  /// In pl, this message translates to:
  /// **'Wyszukiwarka grobów CUI Wrocław'**
  String get location_source_cui;

  /// Location taken from the university's list
  ///
  /// In pl, this message translates to:
  /// **'Wykaz Politechniki Wrocławskiej'**
  String get location_source_spreadsheet;

  /// Any other location source
  ///
  /// In pl, this message translates to:
  /// **'Inne źródło'**
  String get location_source_other;

  /// Label for the person's education
  ///
  /// In pl, this message translates to:
  /// **'Wykształcenie'**
  String get grave_education;

  /// Label for subjects the person taught
  ///
  /// In pl, this message translates to:
  /// **'Przedmioty'**
  String get grave_subjects;

  /// Label for the person's achievements
  ///
  /// In pl, this message translates to:
  /// **'Osiągnięcia'**
  String get grave_achievements;

  /// Expandable section with notes from the CMS
  ///
  /// In pl, this message translates to:
  /// **'Notatki'**
  String get grave_notes;

  /// Label for the grave's GPS coordinates
  ///
  /// In pl, this message translates to:
  /// **'Współrzędne'**
  String get grave_coordinates;

  /// Distance between the user and the grave
  ///
  /// In pl, this message translates to:
  /// **'{distance} od Ciebie'**
  String grave_distance_from_you(String distance);

  /// Location measured on site by a volunteer (Directus value: volunteer)
  ///
  /// In pl, this message translates to:
  /// **'Pomiar wolontariusza w terenie'**
  String get location_source_volunteer;

  /// Screen reader label of an external link icon
  ///
  /// In pl, this message translates to:
  /// **'Otwórz link'**
  String get action_open_link;

  /// Login status: logging in
  ///
  /// In pl, this message translates to:
  /// **'logowanie…'**
  String get auth_status_in_progress;

  /// Login status: logged in
  ///
  /// In pl, this message translates to:
  /// **'zalogowano'**
  String get auth_status_logged_in;

  /// Login status: the server refused the login
  ///
  /// In pl, this message translates to:
  /// **'logowanie nie powiodło się'**
  String get auth_status_failed;

  /// Login status: offline, session kept
  ///
  /// In pl, this message translates to:
  /// **'brak połączenia, zalogujemy po jego odzyskaniu'**
  String get auth_status_offline;

  /// Login failed because the server could not be reached
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia z serwerem. Spróbuj ponownie, gdy wróci internet.'**
  String get login_offline;

  /// Button label after the visit has been saved
  ///
  /// In pl, this message translates to:
  /// **'Odwiedzono'**
  String get visit_marked;

  /// Snackbar after a visit is saved
  ///
  /// In pl, this message translates to:
  /// **'Zapisano wizytę'**
  String get visit_saved;

  /// Snackbar when saving a visit fails
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zapisać wizyty. Spróbuj ponownie.'**
  String get visit_save_failed;

  /// Snackbar when offline
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia – nie można teraz zapisać wizyty.'**
  String get visit_offline;

  /// Snackbar when login is still running
  ///
  /// In pl, this message translates to:
  /// **'Trwa logowanie, spróbuj za chwilę.'**
  String get visit_login_in_progress;

  /// Snackbar when user position is unknown
  ///
  /// In pl, this message translates to:
  /// **'Nie znamy Twojej lokalizacji. Włącz GPS i zezwól aplikacji na dostęp do lokalizacji.'**
  String get visit_no_location;

  /// Snackbar when the user is too far from the grave
  ///
  /// In pl, this message translates to:
  /// **'Jesteś za daleko od grobu ({distance}). Podejdź bliżej – do {limit}.'**
  String visit_too_far(String distance, String limit);

  /// Visit count and last visit date of the user for this grave
  ///
  /// In pl, this message translates to:
  /// **'Twoje wizyty: {count} · ostatnio {date}'**
  String grave_visits_summary(String count, String date);

  /// Shown when the user has never visited the grave
  ///
  /// In pl, this message translates to:
  /// **'Nie masz jeszcze wizyt przy tym grobie'**
  String get grave_visits_none;

  /// Tab with the user's visit history for the grave
  ///
  /// In pl, this message translates to:
  /// **'Moje wizyty'**
  String get grave_tab_my_visits;

  /// Visit history tab when logged out
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się, aby zapisywać wizyty i widzieć ich historię.'**
  String get grave_visits_login_prompt;

  /// Visit history tab while login is in progress, offline or failed
  ///
  /// In pl, this message translates to:
  /// **'Historia wizyt będzie dostępna po zalogowaniu.'**
  String get grave_visits_unavailable;

  /// Visit history failed to load
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać historii wizyt.'**
  String get grave_visits_error;

  /// Title of the dialog asking to confirm a second visit on the same day
  ///
  /// In pl, this message translates to:
  /// **'Dzisiejsza wizyta jest już zapisana'**
  String get visit_again_today_title;

  /// Body of the second-visit confirmation dialog
  ///
  /// In pl, this message translates to:
  /// **'Masz już zapisaną dzisiejszą wizytę przy tym grobie (o {time}). Czy na pewno chcesz zapisać kolejną?'**
  String visit_again_today_body(String time);

  /// Confirm button of the second-visit dialog
  ///
  /// In pl, this message translates to:
  /// **'Zapisz kolejną'**
  String get visit_again_today_confirm;

  /// Generic cancel button
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get action_cancel;

  /// Button and screen title for adding grave photos
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zdjęcia'**
  String get add_photos;

  /// Intro of the correction form
  ///
  /// In pl, this message translates to:
  /// **'Zmień tylko to, co wymaga poprawy. Zgłoszenie sprawdzi moderator, zanim zmiany pojawią się w aplikacji.'**
  String get correction_intro;

  /// Intro of the add-photos form
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zdjęcia grobu. Pojawią się w aplikacji po sprawdzeniu przez moderatora.'**
  String get photo_intro;

  /// Section header in the correction form
  ///
  /// In pl, this message translates to:
  /// **'Osoba'**
  String get correction_section_person;

  /// Section header in the correction form
  ///
  /// In pl, this message translates to:
  /// **'Miejsce'**
  String get correction_section_place;

  /// Section header in the correction form
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcia'**
  String get correction_section_photos;

  /// Form field label
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get field_first_name;

  /// Form field label
  ///
  /// In pl, this message translates to:
  /// **'Nazwisko'**
  String get field_last_name;

  /// Form field label
  ///
  /// In pl, this message translates to:
  /// **'Data urodzenia'**
  String get field_birth_date;

  /// Form field label
  ///
  /// In pl, this message translates to:
  /// **'Data śmierci'**
  String get field_death_date;

  /// Clears a date field
  ///
  /// In pl, this message translates to:
  /// **'Wyczyść'**
  String get correction_clear;

  /// Empty choice in the cemetery picker
  ///
  /// In pl, this message translates to:
  /// **'Nie wiem / brak'**
  String get correction_cemetery_none;

  /// Pick a photo with the camera
  ///
  /// In pl, this message translates to:
  /// **'Zrób zdjęcie'**
  String get correction_photo_camera;

  /// Pick photos from the gallery
  ///
  /// In pl, this message translates to:
  /// **'Wybierz z galerii'**
  String get correction_photo_gallery;

  /// Removes a picked photo
  ///
  /// In pl, this message translates to:
  /// **'Usuń zdjęcie'**
  String get correction_photo_remove;

  /// Too many photos picked
  ///
  /// In pl, this message translates to:
  /// **'Możesz dodać maksymalnie {count} zdjęć.'**
  String correction_photos_limit(String count);

  /// Free-text field in the correction form
  ///
  /// In pl, this message translates to:
  /// **'Komentarz lub źródło informacji'**
  String get correction_comment;

  /// Submit button of the correction form
  ///
  /// In pl, this message translates to:
  /// **'Wyślij zgłoszenie'**
  String get correction_submit;

  /// Progress while uploading photos
  ///
  /// In pl, this message translates to:
  /// **'Wysyłanie zdjęć {done}/{total}…'**
  String correction_uploading(String done, String total);

  /// Submitting a correction without any change
  ///
  /// In pl, this message translates to:
  /// **'Nic nie zostało zmienione.'**
  String get correction_nothing_changed;

  /// Submitting the add-photos form without photos
  ///
  /// In pl, this message translates to:
  /// **'Dodaj przynajmniej jedno zdjęcie.'**
  String get correction_no_photos;

  /// Snackbar after sending a correction
  ///
  /// In pl, this message translates to:
  /// **'Dziękujemy! Zgłoszenie trafiło do moderacji.'**
  String get correction_sent;

  /// Sending a correction failed
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się wysłać zgłoszenia. Spróbuj ponownie.'**
  String get correction_failed;

  /// Dialog when leaving the form with unsaved edits
  ///
  /// In pl, this message translates to:
  /// **'Odrzucić zmiany?'**
  String get correction_discard_title;

  /// Dialog body when leaving the form
  ///
  /// In pl, this message translates to:
  /// **'Wprowadzone zmiany nie zostaną wysłane.'**
  String get correction_discard_body;

  /// Confirms leaving the form
  ///
  /// In pl, this message translates to:
  /// **'Odrzuć'**
  String get correction_discard_confirm;

  /// Title of the map location picker
  ///
  /// In pl, this message translates to:
  /// **'Wskaż lokalizację grobu'**
  String get location_picker_title;

  /// Hint shown on the location picker
  ///
  /// In pl, this message translates to:
  /// **'Przesuń mapę tak, aby pinezka wskazywała dokładnie grób.'**
  String get location_picker_hint;

  /// Confirms the picked location
  ///
  /// In pl, this message translates to:
  /// **'Wybierz tę lokalizację'**
  String get location_picker_confirm;

  /// Switches the picker to aerial imagery
  ///
  /// In pl, this message translates to:
  /// **'Widok satelitarny'**
  String get location_picker_satellite;

  /// Switches the picker to the regular map
  ///
  /// In pl, this message translates to:
  /// **'Zwykła mapa'**
  String get location_picker_map;

  /// Shows the user's position on the picker map
  ///
  /// In pl, this message translates to:
  /// **'Pokaż moją lokalizację'**
  String get location_picker_show_me;

  /// Hides the user's position on the picker map
  ///
  /// In pl, this message translates to:
  /// **'Ukryj moją lokalizację'**
  String get location_picker_hide_me;

  /// Moves the picker map to the user's position
  ///
  /// In pl, this message translates to:
  /// **'Przejdź do mojej lokalizacji'**
  String get location_picker_go_to_me;

  /// Legend for the grave's current location marker
  ///
  /// In pl, this message translates to:
  /// **'Obecna lokalizacja w aplikacji'**
  String get location_picker_current;

  /// Row in the correction form
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja grobu'**
  String get correction_location_title;

  /// No new location picked
  ///
  /// In pl, this message translates to:
  /// **'Bez zmian'**
  String get correction_location_unchanged;

  /// A new location was picked
  ///
  /// In pl, this message translates to:
  /// **'Nowa: {coordinates}'**
  String correction_location_picked(String coordinates);

  /// Opens the map location picker
  ///
  /// In pl, this message translates to:
  /// **'Wskaż na mapie'**
  String get correction_location_pick;

  /// Screen reader label of a picked photo thumbnail
  ///
  /// In pl, this message translates to:
  /// **'Dodane zdjęcie'**
  String get correction_photo_preview;

  /// Screen reader label of the pin in the middle of the picker map
  ///
  /// In pl, this message translates to:
  /// **'Wybrany punkt'**
  String get location_picker_pin;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
