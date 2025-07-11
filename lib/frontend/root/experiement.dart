import 'package:flutter/material.dart';

class Experiement extends StatefulWidget {
  const Experiement({super.key});

  @override
  State<Experiement> createState() => _ExperiementState();
}

class _ExperiementState extends State<Experiement> {
  double topHeight = 300;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isCompact = screenWidth < 900;
    bool isSplit = screenWidth == 900;

    return Scaffold(
      body: Row(
        children: [
          if (screenWidth > 900)
            Container(
              width: 300,
              height: double.infinity,
              color: Colors.white,
              child: const Center(child: Text("screen 1")),
            ),

          // Compact mode with draggable splitter
          if (isCompact)
            Container(
              width: 350,
              height: double.infinity,
              color: Colors.white,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      // Top resizable part
                      Container(
                        height: topHeight,
                        width: double.infinity,
                        color: Colors.blue.shade50,
                        child: const Center(child: Text("Top Part")),
                      ),

                      // Draggable divider
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onPanUpdate: (details) {
                          setState(() {
                            topHeight += details.delta.dy;
                            // clamp values to prevent overflow
                            topHeight = topHeight.clamp(100.0, constraints.maxHeight - 100);
                          });
                        },
                        child: Container(
                          height: 10,
                          color: Colors.blue.shade200,
                          child: const Center(
                            child: Icon(Icons.drag_handle, size: 16, color: Colors.black54),
                          ),
                        ),
                      ),

                      // Bottom expanding part
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.blue.shade100,
                          child: const Center(child: Text("Remaining Height")),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // Main content
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Text(
                  isCompact || isSplit
                      ? "Main Content (Compact)"
                      : "Main Content",
                ),
              ),
            ),
          ),

          if (screenWidth > 900)
            Container(width: 1, color: Colors.black12),

          if (screenWidth > 900)
            Container(
              width: 350,
              height: double.infinity,
              color: Colors.white,
              child: const Center(child: Text("screen 2")),
            ),
        ],
      ),
    );
  }
}
