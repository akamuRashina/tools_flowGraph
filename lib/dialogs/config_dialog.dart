import 'package:flutter/material.dart';
import '../models/panel_model.dart';

/// Config dialog — styled like the white "Konfigurasi Panel" popup in the design.
class ConfigDialog extends StatefulWidget {
  final PanelModel panel;

  const ConfigDialog({super.key, required this.panel});

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  late TextEditingController _nameCtrl;
  late int _deviceId;
  late String _unit;
  int _step = 0; // 0 = basic config, 1 = ordinal / image config
  final int _totalSteps = 2;

  // Ordinal descriptions
  final List<TextEditingController> _descCtrl = [
    TextEditingController(text: 'Mati'),
    TextEditingController(text: 'Nyala'),
  ];
  int _activeDesc = 0;

  static const _units = ['%', '°C', '°F', 'V', 'A', 'W', 'Hz', 'RPM', 'L/s'];
  static const _idOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.panel.name);
    _deviceId = widget.panel.deviceId.clamp(1, 10);
    _unit = _units.contains(widget.panel.unit) ? widget.panel.unit : '%';

    if (widget.panel.descriptions.isNotEmpty) {
      for (int i = 0; i < widget.panel.descriptions.length && i < 2; i++) {
        _descCtrl[i].text = widget.panel.descriptions[i];
      }
    }
    _activeDesc = widget.panel.selectedDescIndex.clamp(0, 1);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    for (final c in _descCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    widget.panel
      ..name = _nameCtrl.text.trim().isEmpty ? widget.panel.name : _nameCtrl.text.trim()
      ..deviceId = _deviceId
      ..unit = _unit
      ..descriptions = _descCtrl.map((c) => c.text).toList()
      ..selectedDescIndex = _activeDesc;
    Navigator.pop(context, widget.panel);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        width: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _step == 0
                    ? _buildStep1()
                    : _buildStep2(),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 8, 10),
      child: Row(
        children: [
          const Text(
            'Konfigurasi Panel',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A3E),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF999999)),
            onPressed: () => Navigator.pop(context),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ID Row
        _RowField(
          leftLabel: 'ID',
          rightWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih No',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12),
              ),
              const SizedBox(width: 2),
              DropdownButton<int>(
                value: _deviceId,
                underline: const SizedBox(),
                isDense: true,
                style:
                    const TextStyle(color: Color(0xFF333333), fontSize: 13),
                items: _idOptions
                    .map((id) => DropdownMenuItem(
                          value: id,
                          child: Text('$id'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _deviceId = v!),
              ),
              const Icon(Icons.chevron_right,
                  size: 16, color: Color(0xFF999999)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Nama
        _label('Nama'),
        const SizedBox(height: 6),
        _inputField(controller: _nameCtrl, hint: 'Nama panel'),
        const SizedBox(height: 14),

        // Unit (%)
        _RowField(
          leftLabel: '%',
          rightWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Unit',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12),
              ),
              const SizedBox(width: 2),
              DropdownButton<String>(
                value: _unit,
                underline: const SizedBox(),
                isDense: true,
                style:
                    const TextStyle(color: Color(0xFF333333), fontSize: 13),
                items: _units
                    .map((u) => DropdownMenuItem(
                          value: u,
                          child: Text(u),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _unit = v!),
              ),
              const Icon(Icons.chevron_right,
                  size: 16, color: Color(0xFF999999)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Duck png & Back png
        Row(
          children: [
            const Expanded(
              child: Text(
                'Duck png & Back png',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Browse',
                style: TextStyle(
                    fontSize: 12, color: Color(0xFF555555)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Deskripsi ordinal'),
        const SizedBox(height: 10),

        // Ordinal number selector
        Row(
          children: List.generate(_descCtrl.length, (i) {
            final selected = i == _activeDesc;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _activeDesc = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFDDDDDD),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF555555),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Off/On image labels
        _RowField(
          leftLabel: 'Off jpg & On jpg',
          rightWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Gambar',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right,
                  size: 16, color: Color(0xFF999999)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Image preview boxes (Mati / Nyala)
        Row(
          children: [
            _ImagePreview(
              label: 'Mati',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _ImagePreview(
              label: 'Nyala',
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Description text field for active ordinal
        _label('Deskripsi ordinal ${_activeDesc + 1}'),
        const SizedBox(height: 6),
        _inputField(
          controller: _descCtrl[_activeDesc],
          hint: 'Contoh: Nyala / Mati',
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Step dots
          Row(
            children: List.generate(_totalSteps, (i) {
              return Container(
                margin: const EdgeInsets.only(right: 5),
                width: i == _step ? 16 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: i == _step
                      ? const Color(0xFFFF6B2C)
                      : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          // Back button
          if (_step > 0) ...[
            _NavBtn(
              icon: Icons.arrow_back,
              onTap: () => setState(() => _step--),
            ),
            const SizedBox(width: 8),
          ],
          // Next / Save button
          if (_step < _totalSteps - 1)
            _NavBtn(
              icon: Icons.arrow_forward,
              onTap: () => setState(() => _step++),
            )
          else
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B2C),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Simpan',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: Color(0xFF999999),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    String? hint,
  }) =>
      TextField(
        controller: controller,
        style: const TextStyle(
            color: Color(0xFF333333), fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Color(0xFFBBBBBB), fontSize: 13),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFFF6B2C)),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────

class _RowField extends StatelessWidget {
  final String leftLabel;
  final Widget rightWidget;

  const _RowField({required this.leftLabel, required this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          leftLabel,
          style: const TextStyle(
              color: Color(0xFF999999), fontSize: 12),
        ),
        const Spacer(),
        rightWidget,
      ],
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF555555)),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ImagePreview({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDDE3F0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_outlined,
                  color: Color(0xFFAAAAAA), size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}