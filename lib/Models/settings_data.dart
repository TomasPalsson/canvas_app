import 'package:canvas_app/Components/loading_enum.dart';
import 'package:hive/hive.dart';

part 'settings_data.g.dart';

@HiveType(typeId: 41)
class SettingsData extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  LoadingWidget loadingWidget;

  @HiveField(2)
  String? canvasToken;

  @HiveField(3)
  String? canvasBaseUrl;

  @HiveField(4)
  String? geminiApiKey;

  @HiveField(5)
  String? openAiApiKey;

  SettingsData({
    required this.isDarkMode,
    required this.loadingWidget,
    this.canvasToken,
    this.canvasBaseUrl,
    this.geminiApiKey,
    this.openAiApiKey,
  });

  @override
  Future<void> save() async {
    print("Saving settings");
    await Hive.box('settings').put('settings', this);
  }
}
