import 'package:flutter/material.dart';
import '../models/panel_model.dart';

class AddPanelPage extends StatelessWidget {
  const AddPanelPage({super.key});

  static const _items = [
    _PanelItem(PanelType.pushOn, 'Push On', Icons.power_settings_new,
        Color(0xFFFF6B2C)),
    _PanelItem(PanelType.toggleSwitch, 'Toggle Switch', Icons.toggle_on,
        Color(0xFF4CAF50)),
    _PanelItem(PanelType.sliderSwitch, 'Slider Switch', Icons.tune,
        Color(0xFF2196F3)),
    _PanelItem(PanelType.rotarySwitch, 'Rotary Switch', Icons.rotate_right,
        Color(0xFFFF9800)),
    _PanelItem(
        PanelType.readPanel, 'Read Panel', Icons.speed, Color(0xFF9C27B0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12122A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A3E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Panel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            Text('Tambahkan panel yang anda butuhkan',
                style: TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return _PanelTypeCard(item: item);
        },
      ),
    );
  }
}

class _PanelItem {
  final PanelType type;
  final String label;
  final IconData icon;
  final Color color;

  const _PanelItem(this.type, this.label, this.icon, this.color);
}

class _PanelTypeCard extends StatefulWidget {
  final _PanelItem item;
  const _PanelTypeCard({required this.item});

  @override
  State<_PanelTypeCard> createState() => _PanelTypeCardState();
}

class _PanelTypeCardState extends State<_PanelTypeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Navigator.pop(context, widget.item.type);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E3F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.item.color.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.item.color.withOpacity(0.12),
                ),
                child: Icon(widget.item.icon,
                    color: widget.item.color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                widget.item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}