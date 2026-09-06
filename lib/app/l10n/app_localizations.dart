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
