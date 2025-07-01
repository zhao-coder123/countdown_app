// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RingTime';

  @override
  String get appSubtitle => 'Beautiful Countdown Timer';

  @override
  String get homeTitle => 'Home';

  @override
  String get addTitle => 'Add Countdown';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get greeting_morning => 'Good Morning!';

  @override
  String get greeting_afternoon => 'Good Afternoon!';

  @override
  String get greeting_evening => 'Good Evening!';

  @override
  String get greeting_subtitle =>
      'Let\'s look forward to wonderful moments together';

  @override
  String get total => 'Total';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get completed => 'Completed';

  @override
  String get expired => 'Expired';

  @override
  String get upcoming_events => 'Upcoming Events';

  @override
  String get all_countdowns => 'All Countdowns';

  @override
  String get no_countdowns => 'No countdowns yet';

  @override
  String get no_countdowns_subtitle =>
      'Tap the + button below to add your first countdown';

  @override
  String get loading => 'Loading...';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get target_date => 'Target Date';

  @override
  String get event_type => 'Event Type';

  @override
  String get color_theme => 'Color Theme';

  @override
  String get title_hint => 'Enter countdown title';

  @override
  String get description_hint => 'Enter description';

  @override
  String get description_optional => 'Description (optional)';

  @override
  String get create_countdown => 'Create Countdown';

  @override
  String get edit_countdown => 'Edit Countdown';

  @override
  String get delete_countdown => 'Delete Countdown';

  @override
  String delete_confirmation(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get event_custom => 'Custom';

  @override
  String get event_birthday => 'Birthday';

  @override
  String get event_anniversary => 'Anniversary';

  @override
  String get event_holiday => 'Holiday';

  @override
  String get event_work => 'Work';

  @override
  String get event_travel => 'Travel';

  @override
  String get days => 'Days';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Seconds';

  @override
  String get day => 'Day';

  @override
  String get hour => 'Hour';

  @override
  String get minute => 'Minute';

  @override
  String get second => 'Second';

  @override
  String get progress => 'Progress';

  @override
  String get event_expired => 'Expired';

  @override
  String get success_created => 'Countdown created successfully!';

  @override
  String get success_updated => 'Countdown updated successfully!';

  @override
  String get success_deleted => 'Countdown deleted successfully!';

  @override
  String get error_title_required => 'Please enter a title';

  @override
  String error_create_failed(Object error) {
    return 'Create failed: $error';
  }

  @override
  String error_update_failed(Object error) {
    return 'Update failed: $error';
  }

  @override
  String error_delete_failed(Object error) {
    return 'Delete failed: $error';
  }

  @override
  String get settings_appearance => 'Appearance Settings';

  @override
  String get settings_function => 'Function Settings';

  @override
  String get settings_data => 'Data Management';

  @override
  String get settings_about => 'About App';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get dark_mode_subtitle => 'Switch between light/dark theme';

  @override
  String get color_theme_title => 'Theme Color';

  @override
  String get color_theme_subtitle => 'Choose your favorite color theme';

  @override
  String get language => 'Language';

  @override
  String get language_subtitle => 'Choose your preferred language';

  @override
  String get notifications => 'Push Notifications';

  @override
  String get notifications_subtitle =>
      'Allow app to send reminder notifications';

  @override
  String get sound_effects => 'Sound Effects';

  @override
  String get sound_effects_subtitle => 'Play sound when countdown completes';

  @override
  String get haptic_feedback => 'Haptic Feedback';

  @override
  String get haptic_feedback_subtitle =>
      'Provide tactile feedback during operations';

  @override
  String get export_data => 'Export Data';

  @override
  String get export_data_subtitle => 'Backup your countdown data';

  @override
  String get clear_data => 'Clear Data';

  @override
  String get clear_data_subtitle => 'Delete all countdown data';

  @override
  String get version_info => 'Version Info';

  @override
  String get developer => 'Developer';

  @override
  String get rate_app => 'Rate App';

  @override
  String get share_app => 'Share App';

  @override
  String get my_countdowns => 'My Countdowns';

  @override
  String get my_countdowns_subtitle => 'Manage your time and goals';

  @override
  String coming_soon(Object feature) {
    return '$feature feature coming soon';
  }

  @override
  String get feature_not_implemented => 'This feature is not implemented yet';

  @override
  String get select_color_theme => 'Select Color Theme';

  @override
  String get select_language => 'Select Language';

  @override
  String get chinese_simplified => '简体中文';

  @override
  String get english => 'English';

  @override
  String get export_success => 'Data exported successfully';

  @override
  String get export_failed => 'Export failed';

  @override
  String get clear_data_confirmation =>
      'Are you sure you want to delete all countdown data? This action cannot be undone.';

  @override
  String get clear_data_success => 'All data cleared successfully';

  @override
  String get clear_data_failed => 'Clear data failed';

  @override
  String get saving => 'Saving...';

  @override
  String get updating => 'Updating...';

  @override
  String get deleting => 'Deleting...';
}
