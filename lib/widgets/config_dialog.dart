import 'package:flutter/material.dart';
import '../models/iot_widget.dart';

class ConfigDialog extends StatefulWidget {
  final IoTWidget widgetData;

  const ConfigDialog({super.key, required this.widgetData});

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.widgetData.title);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Konfigurasi Panel",
                style: TextStyle(fontSize: 18)),

            const SizedBox(height: 16),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.widgetData.width = 120;
                      widget.widgetData.height = 120;
                    },
                    child: const Text("Persegi"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.widgetData.width = 220;
                      widget.widgetData.height = 120;
                    },
                    child: const Text("Persegi Panjang"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                widget.widgetData.title = controller.text;
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}