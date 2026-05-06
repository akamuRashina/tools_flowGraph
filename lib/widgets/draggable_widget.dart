import 'package:flutter/material.dart';
import '../models/iot_widget.dart';
import 'config_dialog.dart';

class DraggableWidget extends StatefulWidget {
  final IoTWidget widgetData;

  const DraggableWidget({super.key, required this.widgetData});

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    width = widget.widgetData.width;
    height = widget.widgetData.height;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          widget.widgetData.x += details.delta.dx;
          widget.widgetData.y += details.delta.dy;
        });
      },
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2B2F),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.power_settings_new,
                        color: Colors.orange),

                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              ConfigDialog(widgetData: widget.widgetData),
                        );
                      },
                      child: const Icon(Icons.settings,
                          color: Colors.white70),
                    ),
                  ],
                ),
                Text(widget.widgetData.title,
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),

          /// RESIZE
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  width += details.delta.dx;
                  height += details.delta.dy;

                  if (width < 100) width = 100;
                  if (height < 100) height = 100;

                  widget.widgetData.width = width;
                  widget.widgetData.height = height;
                });
              },
              child: Container(
                width: 18,
                height: 18,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}