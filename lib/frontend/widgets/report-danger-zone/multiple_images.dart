import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/image_helper.dart';

class MultipleImages extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const MultipleImages({super.key, required this.onImagesSelected});

  @override
  State<MultipleImages> createState() => _MultipleImagesState();
}

class _MultipleImagesState extends State<MultipleImages> {
  final List<File> _images = [];

  final double imageSize = 150.0;
  final double buttonSize = 100.0;

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesSelected(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    final files = await ImageHelper().pickImage(multiple: true);
                    if (files.isNotEmpty) {
                      setState(() {
                        _images
                            .addAll(files.map((e) => File(e!.path)).toList());
                      });
                      widget.onImagesSelected(_images);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8), 
                      border: Border.all(
                        color: const Color(0xff707070), 
                        width: 2.0, 
                      ),
                    ),
                    child: Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 36.0, color: Colors.grey),
                          SizedBox(height: 8.0),
                          Text(
                            "Upload Photos",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (_images.isNotEmpty) buildImageWithRemoveButton(0),
              ],
            ),
            const SizedBox(height: 10),
            if (_images.length > 1)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _images
                    .asMap()
                    .entries
                    .skip(1)
                    .map((entry) => buildImageWithRemoveButton(entry.key))
                    .toList(),
              ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget buildImageWithRemoveButton(int index) {
    return Stack(
      children: [
        Image.file(
          _images[index],
          height: imageSize,
          width: imageSize,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => removeImage(index),
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Color.fromARGB(255, 238, 238, 238),
              child: Icon(
                Icons.close,
                size: 18,
                color: Color.fromARGB(255, 41, 41, 41),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
