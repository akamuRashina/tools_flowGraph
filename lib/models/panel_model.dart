enum PanelType {
  pushOn,
  toggleSwitch,
  sliderSwitch,
  rotarySwitch,
  readPanel,
}

extension PanelTypeExtension on PanelType {
  String get displayName {
    switch (this) {
      case PanelType.pushOn:        return 'Push On';
      case PanelType.toggleSwitch:  return 'Toggle Switch';
      case PanelType.sliderSwitch:  return 'Slider Switch';
      case PanelType.rotarySwitch:  return 'Rotary Switch';
      case PanelType.readPanel:     return 'Read Panel';
    }
  }
}

class PanelModel {
  final String id;
  String name;
  String unit;
  PanelType type;

  // Position & size on canvas (free resize)
  double x;
  double y;
  double width;
  double height;

  // Runtime values
  bool isOn;
  double sliderValue;
  double rotaryValue;
  double readValue;

  // Config
  int deviceId;
  String? offImagePath;
  String? onImagePath;
  List<String> descriptions;
  int selectedDescIndex;

  PanelModel({
    required this.id,
    required this.name,
    required this.type,
    this.unit = '%',
    this.x = 20,
    this.y = 20,
    this.width = 160,
    this.height = 160,
    this.isOn = false,
    this.sliderValue = 0.5,
    this.rotaryValue = 0.0,
    this.readValue = 80,
    this.deviceId = 1,
    this.offImagePath,
    this.onImagePath,
    this.descriptions = const [],
    this.selectedDescIndex = 0,
  });
}