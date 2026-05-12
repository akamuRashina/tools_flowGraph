import 'package:flutter/material.dart';
import '../models/panel_model.dart';
import '../widgets/panel_card.dart';
import 'add_panel_page.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final List<PanelModel> _panels = [
    PanelModel(
      id: '1',
      name: 'Push On',
      type: PanelType.pushOn,
      x: 16,
      y: 16,
      width: 160,
      height: 160,
    ),
    PanelModel(
      id: '2',
      name: 'Toggle Switch',
      type: PanelType.toggleSwitch,
      x: 192,
      y: 16,
      width: 160,
      height: 160,
    ),
    PanelModel(
      id: '3',
      name: 'Slider Switch',
      type: PanelType.sliderSwitch,
      x: 16,
      y: 192,
      width: 336,
      height: 160,
    ),
    PanelModel(
      id: '4',
      name: 'Rotary Switch',
      type: PanelType.rotarySwitch,
      x: 16,
      y: 368,
      width: 160,
      height: 160,
    ),
    PanelModel(
      id: '5',
      name: 'Read Panel',
      type: PanelType.readPanel,
      x: 192,
      y: 368,
      width: 160,
      height: 160,
    ),
  ];

  String? _activeId;

  void _addPanel(PanelType type) {
    setState(() {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      _panels.add(PanelModel(
        id: id,
        name: type.displayName,
        type: type,
        x: 30,
        y: 30,
      ));
      _activeId = id;
    });
  }

  void _updatePanel(PanelModel updated) {
    setState(() {
      final i = _panels.indexWhere((p) => p.id == updated.id);
      if (i != -1) _panels[i] = updated;
    });
  }

  void _removePanel(String id) {
    setState(() => _panels.removeWhere((p) => p.id == id));
  }

  void _bringToFront(String id) {
    setState(() {
      final i = _panels.indexWhere((p) => p.id == id);
      if (i != -1 && i != _panels.length - 1) {
        final panel = _panels.removeAt(i);
        _panels.add(panel);
      }
      _activeId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12122A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A3E),
        elevation: 0,
        title: const Text(
          'Canvas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_outlined,
                size: 18, color: Color(0xFFFF6B2C)),
            label: const Text('Save',
                style: TextStyle(color: Color(0xFFFF6B2C))),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Dot-grid background
          CustomPaint(
            painter: _DotGridPainter(),
            child: const SizedBox.expand(),
          ),
          // Panels rendered in order — last = on top
          ..._panels.map(
            (panel) => PanelCard(
              key: ValueKey(panel.id),
              panel: panel,
              isActive: _activeId == panel.id,
              onTouchDown: () => _bringToFront(panel.id),
              onUpdate: _updatePanel,
              onDelete: () => _removePanel(panel.id),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final type = await Navigator.push<PanelType>(
            context,
            MaterialPageRoute(builder: (_) => const AddPanelPage()),
          );
          if (type != null) _addPanel(type);
        },
        backgroundColor: const Color(0xFF6C3BFF),
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    const spacing = 32.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}