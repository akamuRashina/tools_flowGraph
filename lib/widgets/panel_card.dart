import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/panel_model.dart';
import '../dialogs/config_dialog.dart';

const double _kMinW = 140.0;
const double _kMinH = 120.0;
const double _kHandleSize = 22.0;

/// A freely draggable & resizable panel card placed via [Positioned].
class PanelCard extends StatefulWidget {
  final PanelModel panel;
  final bool isActive;
  final VoidCallback onTouchDown;
  final ValueChanged<PanelModel> onUpdate;
  final VoidCallback onDelete;

  const PanelCard({
    super.key,
    required this.panel,
    required this.isActive,
    required this.onTouchDown,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<PanelCard> createState() => _PanelCardState();
}

class _PanelCardState extends State<PanelCard> {
  // Local copies so we can update without waiting for parent rebuild
  late double _x, _y, _w, _h;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _x = widget.panel.x;
    _y = widget.panel.y;
    _w = widget.panel.width;
    _h = widget.panel.height;
  }

  @override
  void didUpdateWidget(PanelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync position/size only if the panel id changes (new panel)
    if (oldWidget.panel.id != widget.panel.id) {
      _x = widget.panel.x;
      _y = widget.panel.y;
      _w = widget.panel.width;
      _h = widget.panel.height;
    }
  }

  void _onMove(DragUpdateDetails d) {
    setState(() {
      _x = math.max(0, _x + d.delta.dx);
      _y = math.max(0, _y + d.delta.dy);
    });
    _notifyParent();
  }

  void _onResize(DragUpdateDetails d) {
    setState(() {
      _w = (_w + d.delta.dx).clamp(_kMinW, 600.0);
      _h = (_h + d.delta.dy).clamp(_kMinH, 600.0);
    });
    _notifyParent();
  }

  void _notifyParent() {
    widget.panel
      ..x = _x
      ..y = _y
      ..width = _w
      ..height = _h;
    widget.onUpdate(widget.panel);
  }

  Future<void> _openConfig() async {
    final result = await showDialog<PanelModel>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ConfigDialog(panel: widget.panel),
    );
    if (result != null) {
      setState(() {});
      widget.onUpdate(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onTapDown: (_) => widget.onTouchDown(),
        onPanStart: (_) {
          if (!_isResizing) widget.onTouchDown();
        },
        onPanUpdate: (d) {
          if (!_isResizing) _onMove(d);
        },
        child: SizedBox(
          width: _w,
          height: _h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Card body ──────────────────────────────────────
              Container(
                width: _w,
                height: _h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E3F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isActive
                        ? const Color(0xFFFF6B2C).withOpacity(0.7)
                        : Colors.white.withOpacity(0.08),
                    width: widget.isActive ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ── Header bar ──────────────────────────────
                    _Header(
                      panel: widget.panel,
                      onSettingsTap: _openConfig,
                      onDelete: widget.onDelete,
                    ),
                    // ── Widget content ──────────────────────────
                    Expanded(
                      child: _PanelBody(
                        panel: widget.panel,
                        onUpdate: widget.onUpdate,
                        rebuild: () => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Resize handle (bottom-right) ───────────────────
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (_) => setState(() => _isResizing = true),
                  onPanUpdate: _onResize,
                  onPanEnd: (_) => setState(() => _isResizing = false),
                  child: Container(
                    width: _kHandleSize,
                    height: _kHandleSize,
                    decoration: BoxDecoration(
                      color: _isResizing
                          ? const Color(0xFFFF6B2C)
                          : const Color(0xFFFF6B2C).withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        topLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Header row: name + gear icon + delete (long-press)
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  final PanelModel panel;
  final VoidCallback onSettingsTap;
  final VoidCallback onDelete;

  const _Header({
    required this.panel,
    required this.onSettingsTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              panel.name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // ── Settings / Gear icon ─────────────────
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSettingsTap,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Icon(
                Icons.settings, // ← GEAR ICON (bukan hamburger)
                size: 17,
                color: Color(0xFFFF6B2C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Panel body — dispatches to each widget type
// ─────────────────────────────────────────────
class _PanelBody extends StatelessWidget {
  final PanelModel panel;
  final ValueChanged<PanelModel> onUpdate;
  final VoidCallback rebuild;

  const _PanelBody({
    required this.panel,
    required this.onUpdate,
    required this.rebuild,
  });

  void _notify() => onUpdate(panel);

  @override
  Widget build(BuildContext context) {
    switch (panel.type) {
      case PanelType.pushOn:
        return _PushOnWidget(
          isOn: panel.isOn,
          onTap: () {
            panel.isOn = !panel.isOn;
            rebuild();
            _notify();
          },
        );
      case PanelType.toggleSwitch:
        return _ToggleWidget(
          isOn: panel.isOn,
          onChanged: (v) {
            panel.isOn = v;
            rebuild();
            _notify();
          },
        );
      case PanelType.sliderSwitch:
        return _SliderWidget(
          value: panel.sliderValue,
          onChanged: (v) {
            panel.sliderValue = v;
            rebuild();
            _notify();
          },
        );
      case PanelType.rotarySwitch:
        return _RotaryWidget(
          value: panel.rotaryValue,
          onChanged: (v) {
            panel.rotaryValue = v;
            rebuild();
            _notify();
          },
        );
      case PanelType.readPanel:
        return _ReadWidget(value: panel.readValue, unit: panel.unit);
    }
  }
}

// ─────────────────────────────────────────────
// Individual widget UIs
// ─────────────────────────────────────────────

class _PushOnWidget extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _PushOnWidget({required this.isOn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOn
                ? const Color(0xFFFF6B2C)
                : const Color(0xFF2A2A4A),
            border: Border.all(
              color: const Color(0xFFFF6B2C),
              width: 2.5,
            ),
            boxShadow: isOn
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF6B2C).withOpacity(0.5),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            Icons.power_settings_new,
            color: isOn ? Colors.white : const Color(0xFFFF6B2C),
            size: 36,
          ),
        ),
      ),
    );
  }
}

class _ToggleWidget extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const _ToggleWidget({required this.isOn, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 1.6,
            child: Switch(
              value: isOn,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFFF6B2C),
              inactiveThumbColor: Colors.white54,
              inactiveTrackColor: Colors.white12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOn ? 'ON' : 'OFF',
            style: TextStyle(
              color: isOn ? const Color(0xFFFF6B2C) : Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderWidget extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _SliderWidget({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFFF6B2C),
              inactiveTrackColor: Colors.white12,
              thumbColor: const Color(0xFFFF6B2C),
              overlayColor: const Color(0xFFFF6B2C).withOpacity(0.2),
              trackHeight: 4,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
          Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              color: Color(0xFFFF6B2C),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RotaryWidget extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _RotaryWidget({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    return Center(
      child: GestureDetector(
        onVerticalDragUpdate: (d) {
          final newVal = (value - d.delta.dy / 150).clamp(0.0, 1.0);
          onChanged(newVal);
        },
        child: SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 9,
                backgroundColor: Colors.white12,
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFFFF6B2C)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$pct%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '↕ drag',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadWidget extends StatelessWidget {
  final double value;
  final String unit;

  const _ReadWidget({required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.round().toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 52,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
              ),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}