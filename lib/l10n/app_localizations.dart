import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'RingTime'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Beautiful Countdown Timer'**
  String get appSubtitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Countdown'**
  String get addTitle;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @greeting_morning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get greeting_morning;

  /// No description provided for @greeting_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon!'**
  String get greeting_afternoon;

  /// No description provided for @greeting_evening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening!'**
  String get greeting_evening;

  /// No description provided for @greeting_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s look forward to wonderful moments together'**
  String get greeting_subtitle;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @upcoming_events.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcoming_events;

  /// No description provided for @all_countdowns.
  ///
  /// In en, this message translates to:
  /// **'All Countdowns'**
  String get all_countdowns;

  /// No description provided for @no_countdowns.
  ///
  /// In en, this message translates to:
  /// **'No countdowns yet'**
  String get no_countdowns;

  /// No description provided for @no_countdowns_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first countdown'**
  String get no_countdowns_subtitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @target_date.
  ///
  /// In en, this message translates to:
  /// **'Target Date'**
  String get target_date;

  /// No description provided for @event_type.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get event_type;

  /// No description provided for @color_theme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get color_theme;

  /// No description provided for @title_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter countdown title'**
  String get title_hint;

  /// No description provided for @description_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get description_hint;

  /// No description provided for @description_optional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get description_optional;

  /// No description provided for @create_countdown.
  ///
  /// In en, this message translates to:
  /// **'Create Countdown'**
  String get create_countdown;

  /// No description provided for @edit_countdown.
  ///
  /// In en, this message translates to:
  /// **'Edit Countdown'**
  String get edit_countdown;

  /// No description provided for @delete_countdown.
  ///
  /// In en, this message translates to:
  /// **'Delete Countdown'**
  String get delete_countdown;

  /// No description provided for @delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String delete_confirmation(Object title);

  /// No description provided for @event_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get event_custom;

  /// No description provided for @event_birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get event_birthday;

  /// No description provided for @event_anniversary.
  ///
  /// In en, this message translates to:
  /// **'Anniversary'**
  String get event_anniversary;

  /// No description provided for @event_holiday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get event_holiday;

  /// No description provided for @event_work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get event_work;

  /// No description provided for @event_travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get event_travel;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get second;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @event_expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get event_expired;

  /// No description provided for @success_created.
  ///
  /// In en, this message translates to:
  /// **'Countdown created successfully!'**
  String get success_created;

  /// No description provided for @success_updated.
  ///
  /// In en, this message translates to:
  /// **'Countdown updated successfully!'**
  String get success_updated;

  /// No description provided for @success_deleted.
  ///
  /// In en, this message translates to:
  /// **'Countdown deleted successfully!'**
  String get success_deleted;

  /// No description provided for @error_title_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get error_title_required;

  /// No description provided for @error_create_failed.
  ///
  /// In en, this message translates to:
  /// **'Create failed: {error}'**
  String error_create_failed(Object error);

  /// No description provided for @error_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String error_update_failed(Object error);

  /// No description provided for @error_delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String error_delete_failed(Object error);

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance Settings'**
  String get settings_appearance;

  /// No description provided for @settings_function.
  ///
  /// In en, this message translates to:
  /// **'Function Settings'**
  String get settings_function;

  /// No description provided for @settings_data.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settings_data;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get settings_about;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @dark_mode_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between light/dark theme'**
  String get dark_mode_subtitle;

  /// No description provided for @color_theme_title.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get color_theme_title;

  /// No description provided for @color_theme_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your favorite color theme'**
  String get color_theme_subtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get language_subtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get notifications;

  /// No description provided for @notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow app to send reminder notifications'**
  String get notifications_subtitle;

  /// No description provided for @sound_effects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get sound_effects;

  /// No description provided for @sound_effects_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Play sound when countdown completes'**
  String get sound_effects_subtitle;

  /// No description provided for @haptic_feedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get haptic_feedback;

  /// No description provided for @haptic_feedback_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide tactile feedback during operations'**
  String get haptic_feedback_subtitle;

  /// No description provided for @export_data.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get export_data;

  /// No description provided for @export_data_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Backup your countdown data'**
  String get export_data_subtitle;

  /// No description provided for @clear_data.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clear_data;

  /// No description provided for @clear_data_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all countdown data'**
  String get clear_data_subtitle;

  /// No description provided for @version_info.
  ///
  /// In en, this message translates to:
  /// **'Version Info'**
  String get version_info;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @rate_app.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rate_app;

  /// No description provided for @share_app.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get share_app;

  /// No description provided for @my_countdowns.
  ///
  /// In en, this message translates to:
  /// **'My Countdowns'**
  String get my_countdowns;

  /// No description provided for @my_countdowns_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your time and goals'**
  String get my_countdowns_subtitle;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'{feature} feature coming soon'**
  String coming_soon(Object feature);

  /// No description provided for @feature_not_implemented.
  ///
  /// In en, this message translates to:
  /// **'This feature is not implemented yet'**
  String get feature_not_implemented;

  /// No description provided for @select_color_theme.
  ///
  /// In en, this message translates to:
  /// **'Select Color Theme'**
  String get select_color_theme;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @chinese_simplified.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get chinese_simplified;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @export_success.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get export_success;

  /// No description provided for @export_failed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get export_failed;

  /// No description provided for @clear_data_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all countdown data? This action cannot be undone.'**
  String get clear_data_confirmation;

  /// No description provided for @clear_data_success.
  ///
  /// In en, this message translates to:
  /// **'All data cleared successfully'**
  String get clear_data_success;

  /// No description provided for @clear_data_failed.
  ///
  /// In en, this message translates to:
  /// **'Clear data failed'**
  String get clear_data_failed;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
