import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/widget_provider.dart';
import '../widgets/draggable_widget.dart';

class CanvasPage extends StatelessWidget {
  const CanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WidgetProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F22),
      body: Stack(
        children: [
          ...provider.widgets.map((w) {
            return Positioned(
              left: w.x,
              top: w.y,
              child: DraggableWidget(widgetData: w),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: provider.addWidget,
        child: const Icon(Icons.add),
      ),
    );
  }
}