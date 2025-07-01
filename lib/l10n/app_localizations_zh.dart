// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '圆时间';

  @override
  String get appSubtitle => '精美的倒计时应用';

  @override
  String get homeTitle => '首页';

  @override
  String get addTitle => '添加倒计时';

  @override
  String get discoverTitle => '发现';

  @override
  String get settingsTitle => '设置';

  @override
  String get greeting_morning => '早上好！';

  @override
  String get greeting_afternoon => '下午好！';

  @override
  String get greeting_evening => '晚上好！';

  @override
  String get greeting_subtitle => '让我们一起期待美好的时刻到来';

  @override
  String get total => '总计';

  @override
  String get upcoming => '即将到来';

  @override
  String get completed => '已完成';

  @override
  String get expired => '已过期';

  @override
  String get upcoming_events => '即将到来';

  @override
  String get all_countdowns => '所有倒计时';

  @override
  String get no_countdowns => '还没有倒计时';

  @override
  String get no_countdowns_subtitle => '点击下方的 + 按钮来添加你的第一个倒计时';

  @override
  String get loading => '加载中...';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get create => '创建';

  @override
  String get update => '更新';

  @override
  String get title => '标题';

  @override
  String get description => '描述';

  @override
  String get target_date => '目标日期';

  @override
  String get event_type => '事件类型';

  @override
  String get color_theme => '颜色主题';

  @override
  String get title_hint => '输入倒计时标题';

  @override
  String get description_hint => '输入描述信息';

  @override
  String get description_optional => '描述（可选）';

  @override
  String get create_countdown => '创建倒计时';

  @override
  String get edit_countdown => '编辑倒计时';

  @override
  String get delete_countdown => '删除倒计时';

  @override
  String delete_confirmation(Object title) {
    return '确定要删除「$title」吗？';
  }

  @override
  String get event_custom => '自定义';

  @override
  String get event_birthday => '生日';

  @override
  String get event_anniversary => '纪念日';

  @override
  String get event_holiday => '节日';

  @override
  String get event_work => '工作';

  @override
  String get event_travel => '旅行';

  @override
  String get days => '天';

  @override
  String get hours => '小时';

  @override
  String get minutes => '分钟';

  @override
  String get seconds => '秒';

  @override
  String get day => '天';

  @override
  String get hour => '时';

  @override
  String get minute => '分';

  @override
  String get second => '秒';

  @override
  String get progress => '进度';

  @override
  String get event_expired => '已过期';

  @override
  String get success_created => '倒计时创建成功！';

  @override
  String get success_updated => '倒计时更新成功！';

  @override
  String get success_deleted => '删除成功！';

  @override
  String get error_title_required => '请输入标题';

  @override
  String error_create_failed(Object error) {
    return '创建失败：$error';
  }

  @override
  String error_update_failed(Object error) {
    return '更新失败：$error';
  }

  @override
  String error_delete_failed(Object error) {
    return '删除失败：$error';
  }

  @override
  String get settings_appearance => '外观设置';

  @override
  String get settings_function => '功能设置';

  @override
  String get settings_data => '数据管理';

  @override
  String get settings_about => '关于应用';

  @override
  String get dark_mode => '深色模式';

  @override
  String get dark_mode_subtitle => '切换浅色/深色主题';

  @override
  String get color_theme_title => '主题色彩';

  @override
  String get color_theme_subtitle => '选择你喜欢的颜色主题';

  @override
  String get language => '语言';

  @override
  String get language_subtitle => '选择你的首选语言';

  @override
  String get notifications => '推送通知';

  @override
  String get notifications_subtitle => '允许应用发送提醒通知';

  @override
  String get sound_effects => '提示音效';

  @override
  String get sound_effects_subtitle => '倒计时完成时播放声音';

  @override
  String get haptic_feedback => '震动反馈';

  @override
  String get haptic_feedback_subtitle => '操作时提供触觉反馈';

  @override
  String get export_data => '导出数据';

  @override
  String get export_data_subtitle => '备份你的倒计时数据';

  @override
  String get clear_data => '清除数据';

  @override
  String get clear_data_subtitle => '删除所有倒计时数据';

  @override
  String get version_info => '版本信息';

  @override
  String get developer => '开发者';

  @override
  String get rate_app => '评价应用';

  @override
  String get share_app => '分享应用';

  @override
  String get my_countdowns => '我的倒计时';

  @override
  String get my_countdowns_subtitle => '管理你的时间与目标';

  @override
  String coming_soon(Object feature) {
    return '$feature 功能即将推出';
  }

  @override
  String get feature_not_implemented => '此功能尚未实现';

  @override
  String get select_color_theme => '选择主题色彩';

  @override
  String get select_language => '选择语言';

  @override
  String get chinese_simplified => '简体中文';

  @override
  String get english => 'English';

  @override
  String get export_success => '数据导出成功';

  @override
  String get export_failed => '导出失败';

  @override
  String get clear_data_confirmation => '确定要删除所有倒计时数据吗？此操作无法撤销。';

  @override
  String get clear_data_success => '所有数据清除成功';

  @override
  String get clear_data_failed => '清除数据失败';

  @override
  String get saving => '正在保存...';

  @override
  String get updating => '正在更新...';

  @override
  String get deleting => '正在删除...';
}
