import 'package:safezone/frontend/platforms/mobile/widgets/report-danger-zone/image_helper.dart';

import '../../../../../backend/properties/import.dart';

class MultipleImages extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const MultipleImages({super.key, required this.onImagesSelected});

  @override
  State<MultipleImages> createState() => _MultipleImagesState();
}

class _MultipleImagesState extends State<MultipleImages> {
  final List<File> _images = [];
  final double imageSize = 150.0;

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesSelected(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-width upload button
            GestureDetector(
              onTap: () async {
                final files = await ImageHelper().pickImage(multiple: true);
                if (files.isNotEmpty) {
                  setState(() {
                    _images.addAll(files.map((e) => File(e!.path)).toList());
                  });
                  widget.onImagesSelected(_images);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xff707070),
                    width: 1.0,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 36.0, color: Colors.grey),
                    SizedBox(height: 8.0),
                    Text(
                      "Upload Photos",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_images.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return buildImageWithRemoveButton(index);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildImageWithRemoveButton(int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            _images[index],
            height: imageSize,
            width: imageSize,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
