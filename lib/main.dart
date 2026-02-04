// lib/main.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_switch/flutter_switch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Panels',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false),
      home: const DashboardPage(),
    );
  }
}

class PanelModel {
  String id;
  PanelType type;
  String name; // configurable
  String pin; // configurable
  PanelModel({required this.id, required this.type, String? name, String? pin})
    : name = name ?? '',
      pin = pin ?? '';
}

enum PanelType { pushOn, toggle, slider, rotary, read }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<PanelModel> _panels = [];

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddPanelBottomSheet(
        onAdd: (PanelType type) {
          setState(() {
            _panels.add(
              PanelModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                type: type,
                name: _defaultNameFor(type),
              ),
            );
          });
        },
      ),
    );
  }

  static String _defaultNameFor(PanelType t) {
    switch (t) {
      case PanelType.pushOn:
        return 'Push On';
      case PanelType.toggle:
        return 'Toggle Switch';
      case PanelType.slider:
        return 'Slider Switch';
      case PanelType.rotary:
        return 'Rotary Switch';
      case PanelType.read:
        return 'Read Panel';
    }
  }

  void _openConfig(String id) async {
    final idx = _panels.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    final panel = _panels[idx];

    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final nameCtrl = TextEditingController(text: panel.name);
        final pinCtrl = TextEditingController(text: panel.pin);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withOpacity(0.03),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Configure Panel',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.02),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pinCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Pin / Value',
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.02),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              ctx,
                            ).pop({'name': nameCtrl.text, 'pin': pinCtrl.text});
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        panel.name = result['name'] ?? panel.name;
        panel.pin = result['pin'] ?? panel.pin;
      });
    }
  }

  void _removePanel(String id) {
    setState(() {
      _panels.removeWhere((p) => p.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int columns = 1;
    if (width >= 1100) columns = 2;
    if (width >= 1500) columns = 3;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      // FIX: use floatingActionButton so it stays fixed and doesn't get affected by scroll/overflow
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        width: 58,
        height: 58,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFEB4F12), Color(0xFFC74E46), Color(0xFF4E4AF2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x802B3445),
              offset: Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _openAddSheet,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 24,
              top: 20,
              child: Text(
                'Dashboard Panel',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 64,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: _panels.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada panel',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth =
                            (constraints.maxWidth - (columns - 1) * 24) /
                            columns;
                        return SingleChildScrollView(
                          child: Wrap(
                            runSpacing: 20,
                            spacing: 24,
                            children: _panels
                                .map(
                                  (p) => SizedBox(
                                    width: itemWidth,
                                    child: PanelContainer(
                                      key: ValueKey(p.id),
                                      id: p.id,
                                      type: p.type,
                                      name: p.name,
                                      pin: p.pin,
                                      onConfig: _openConfig,
                                      onRemove: _removePanel,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PanelContainer: compute height dynamically from width using aspect ratio per type
class PanelContainer extends StatelessWidget {
  final String id;
  final PanelType type;
  final void Function(String id) onRemove;
  final void Function(String id) onConfig;
  final String name;
  final String pin;

  const PanelContainer({
    super.key,
    required this.id,
    required this.type,
    required this.onRemove,
    required this.onConfig,
    required this.name,
    required this.pin,
  });

  double _aspectRatioFor(PanelType t) {
    // aspectRatio = width / height
    switch (t) {
      case PanelType.pushOn:
      case PanelType.toggle:
      case PanelType.slider:
      case PanelType.rotary:
        return 170.0 / 96.0; // small card ratio
      case PanelType.read:
        return 347.0 / 96.0; // read panel ratio
    }
  }

  String _label() {
    switch (type) {
      case PanelType.pushOn:
        return name.isNotEmpty ? name : 'Push On';
      case PanelType.toggle:
        return name.isNotEmpty ? name : 'Toggle Switch';
      case PanelType.slider:
        return name.isNotEmpty ? name : 'Slider Switch';
      case PanelType.rotary:
        return name.isNotEmpty ? name : 'Rotary Switch';
      case PanelType.read:
        return name.isNotEmpty ? name : 'Read Panel';
    }
  }

  Widget _panelBody() {
    switch (type) {
      case PanelType.pushOn:
        return const PanelPushOn();
      case PanelType.toggle:
        return const PanelToggle();
      case PanelType.slider:
        return const PanelSlider();
      case PanelType.rotary:
        return const PanelRotary();
      case PanelType.read:
        return PanelRead(initialValueText: pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final aspect = _aspectRatioFor(type);
        final bodyHeight =
            width / (aspect.isFinite && aspect > 0 ? aspect : 1.77);
        // header height estimate
        const headerHeight = 44.0;
        final totalHeight = headerHeight + bodyHeight + 28; // paddings

        return Container(
          height: totalHeight,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.02),
                Colors.white.withOpacity(0.01),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 6),
                blurRadius: 18,
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // header row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _label(),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.92),
                            ),
                          ),
                        ),
                        // config (hamburger) now opens config modal
                        GestureDetector(
                          onTap: () => onConfig(id),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(Icons.menu, color: Colors.white60),
                          ),
                        ),
                        // optional remove (small trash) — keep accessible
                        GestureDetector(
                          onTap: () => onRemove(id),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // panel body with exact height computed from width/aspect
                    SizedBox(
                      width: width,
                      height: bodyHeight,
                      child: _panelBody(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ----------------------
/// Panel Widgets (interaktif dasar)
/// ----------------------

// Push On
class PanelPushOn extends StatefulWidget {
  const PanelPushOn({super.key});
  @override
  State<PanelPushOn> createState() => _PanelPushOnState();
}

class _PanelPushOnState extends State<PanelPushOn> {
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => setState(() => isOn = !isOn),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isOn
                ? const LinearGradient(
                    colors: [Color(0xFFFF8A00), Color(0xFFE94614)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF2A2A2A), Color(0xFF2A2A2A)],
                  ),
            boxShadow: [
              BoxShadow(
                color: isOn
                    ? Colors.orange.withOpacity(0.4)
                    : Colors.black.withOpacity(0.4),
                blurRadius: isOn ? 24 : 6,
                spreadRadius: isOn ? 4 : 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1E1E1E),
            ),
            child: Center(
              child: Icon(
                Icons.power_settings_new,
                size: 36,
                color: isOn ? Colors.white : Colors.orange,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Toggle (flutter_switch)
class PanelToggle extends StatefulWidget {
  const PanelToggle({super.key});
  @override
  State<PanelToggle> createState() => _PanelToggleState();
}

class _PanelToggleState extends State<PanelToggle> {
  bool val = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterSwitch(
        width: 150,
        height: 70,
        toggleSize: 56,
        value: val,
        borderRadius: 36,
        padding: 6,
        showOnOff: false,
        activeColor: const Color(0xFF94FD01),
        inactiveColor: const Color(0xFFD9D9D9),
        activeToggleColor: Colors.white,
        inactiveToggleColor: const Color(0xFFFF8A00),
        onToggle: (v) => setState(() => val = v),
      ),
    );
  }
}

// Slider
class PanelSlider extends StatefulWidget {
  const PanelSlider({super.key});
  @override
  State<PanelSlider> createState() => _PanelSliderState();
}

class _PanelSliderState extends State<PanelSlider> {
  double value = 0.2;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 14,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          thumbColor: const Color(0xFFFF8A00),
          activeTrackColor: const Color(0xFF94FD01),
          inactiveTrackColor: const Color(0xFFD9D9D9),
        ),
        child: Slider(
          min: 0,
          max: 1,
          divisions: 100,
          value: value,
          onChanged: (v) => setState(() => value = v),
        ),
      ),
    );
  }
}

// Rotary (sleek_circular_slider)
class PanelRotary extends StatefulWidget {
  const PanelRotary({super.key});
  @override
  State<PanelRotary> createState() => _PanelRotaryState();
}

class _PanelRotaryState extends State<PanelRotary> {
  double percent = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SleekCircularSlider(
        min: 0,
        max: 100,
        initialValue: percent,
        appearance: CircularSliderAppearance(
          size: 140,
          customWidths: CustomSliderWidths(
            progressBarWidth: 12,
            handlerSize: 18,
            trackWidth: 12,
          ),
          customColors: CustomSliderColors(
            progressBarColors: const [Color(0xFFFA8104), Color(0xFFE94614)],
            trackColor: Colors.white.withOpacity(0.06),
            dotColor: const Color(0xFFFF8A00),
          ),
          infoProperties: InfoProperties(
            mainLabelStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            modifier: (value) => '${value.toInt()}%',
          ),
          startAngle: 140,
          angleRange: 260,
        ),
        onChange: (v) => setState(() => percent = v),
      ),
    );
  }
}

// Read panel
class PanelRead extends StatefulWidget {
  final String initialValueText;
  const PanelRead({super.key, this.initialValueText = ''});
  @override
  State<PanelRead> createState() => _PanelReadState();
}

class _PanelReadState extends State<PanelRead> {
  double value = 80;
  @override
  void initState() {
    super.initState();
    // if initial text given (from config), try parse
    final t = widget.initialValueText;
    if (t.isNotEmpty) {
      final parsed = double.tryParse(t);
      if (parsed != null) value = parsed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value.toInt().toString(),
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: ' cc',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Add Panel Sheet (unchanged, closes on selection and calls callback)
class AddPanelBottomSheet extends StatelessWidget {
  final void Function(PanelType) onAdd;
  const AddPanelBottomSheet({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 900 ? 900.0 : screenWidth * 0.94;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.62,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.02),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 48,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFD9201),
                                          Color(0xFF4E4AF2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x802B3445),
                                          offset: Offset(0, 8),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Add Panel',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tambahkan panel yang anda butuhkan',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 18),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final double avail = constraints.maxWidth;
                                const spacing = 14.0;
                                final smallWidth = (avail - spacing) / 2;
                                final smallHeight = smallWidth * (96 / 170);
                                final readH = avail * (96 / 347);

                                Widget box(
                                  String label,
                                  PanelType type, {
                                  double? w,
                                  double? h,
                                }) {
                                  return SizedBox(
                                    width: w ?? smallWidth,
                                    height: h ?? smallHeight,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          onAdd(type);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.04,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                offset: Offset(0, 8),
                                                blurRadius: 18,
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            top: 12,
                                            right: 12,
                                            bottom: 12,
                                          ),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  label,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                        .withOpacity(0.88),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  width: 33,
                                                  height: 33,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            Color(0xFFFD9201),
                                                            Color(0xFFE94614),
                                                          ],
                                                        ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color(
                                                          0x30000000,
                                                        ),
                                                        offset: Offset(0, 6),
                                                        blurRadius: 10,
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        box('Push On', PanelType.pushOn),
                                        const SizedBox(width: spacing),
                                        box('Switch Toggle', PanelType.toggle),
                                      ],
                                    ),
                                    const SizedBox(height: spacing),
                                    Row(
                                      children: [
                                        box('Rotary Switch', PanelType.rotary),
                                        const SizedBox(width: spacing),
                                        box('Slider Switch', PanelType.slider),
                                      ],
                                    ),
                                    const SizedBox(height: spacing),
                                    box(
                                      'Read Panel',
                                      PanelType.read,
                                      w: avail,
                                      h: readH,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
