import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Map extends StatefulWidget {

  final String UserToken;
  
  const Map({
    super.key,
    required this.UserToken
  });

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> with TickerProviderStateMixin {

  final Completer<GoogleMapController> _mapController = Completer();
  static const LatLng sourceLocation = LatLng(16.043859, 120.335182);
  // static const LatLng destinationLocation = LatLng(16.053859, 120.335182);

  BitmapDescriptor? customMarker;

  late AnimationController _controller;
  late Animation<Offset> _hintAnimation;
  late Animation<Color?> _hintColorAnimation;
  late FocusNode _focusNode;
  late AnimationController _controllerFade;
  late Animation<Color?> _colorAnimation;
  late TextEditingController _textEditingController;
  bool _isFadedOut = false;

  late AnimationController _mapCategoryHint; 

  final List<String> hints = [
    'Barangay',
    'Hospial',
    'Police Station',
    'Municipal',
  ];

  int _currentHintIndex = 0;

  @override
  void initState() {
    super.initState();

    _checkFirstRun();

    _createCustomMarker();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controllerFade = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _mapCategoryHint = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _mapCategoryHint.repeat();

    _hintAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1), 
    ).animate(_controller);

    _hintColorAnimation = ColorTween(
      begin: Colors.black.withOpacity(0.5), 
      end: const Color.fromARGB(0, 148, 37, 37), 
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.black87,
      end: Colors.transparent, 
    ).animate(_controllerFade);

    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _changeHintText();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controllerFade.forward();
        _controller.forward();
      } else if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.reverse();
        _controllerFade.reverse();
      }
    });

  }
  
  Future<void> _createCustomMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double pinWidth = 60; 
    const double pinHeight = 90;
    const double imageSize = 40; 

    final Paint pinPaint = Paint()..color = widgetPricolor;
    final Path pinPath = Path()
      ..moveTo(pinWidth / 2, pinHeight)
      ..lineTo(0, pinHeight / 3) 
      ..arcToPoint(
        Offset(pinWidth, pinHeight / 3),
        radius: Radius.circular(pinWidth / 5),
        clockwise: true, 
      )
      ..close();
    canvas.drawPath(pinPath, pinPaint);

    final Rect imageRect = Rect.fromCircle(
      center: Offset(pinWidth / 2, pinHeight / 3 - imageSize / 10),
      radius: imageSize / 2,
    );

    final ui.Image image = await _loadImage('lib/resources/images/miro.png');
    paintImage(
      canvas: canvas,
      rect: imageRect,
      image: image,
      fit: BoxFit.cover,
    );

    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
      pinWidth.toInt(),
      pinHeight.toInt(),
    );
    final ByteData? byteData = await markerImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List imageData = byteData!.buffer.asUint8List();

    setState(() {
      customMarker = BitmapDescriptor.fromBytes(imageData);
    });
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final ByteData data = await DefaultAssetBundle.of(context).load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  void _toggleTextVisibility() {
    if (_isFadedOut) {
      _controllerFade.reverse();
    } else {
      _controllerFade.forward();
    }

    setState(() {
      _isFadedOut = !_isFadedOut;
    });
  }

  void _changeHintText() {
    Future.delayed(Duration(seconds: 2), () {
      if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.forward().then((_) {
          setState(() {
            _currentHintIndex = (_currentHintIndex + 1) % hints.length;
          });
          _controller.reverse().then((_) {
            _changeHintText(); 
          });
        });
      } else {
        _changeHintText(); 
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerFade.dispose();
    _mapCategoryHint.dispose();
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void getPolyPoints() async {

  }

  // Check if it's the first run
  Future<void> _checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRun = prefs.getBool('isFirstRun');
    
    if (isFirstRun == null || isFirstRun) {
      _showFirstRunDialog();
      prefs.setBool('isFirstRun', false);  // Set the flag so it doesn't show again
    }
  }

  void _showFirstRunDialog() {
  final PageController _pageController = PageController();

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: SizedBox(
        width: 250,
        height: 330,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              child: ClipRRect(
                                child: Image.asset(
                                  'lib/resources/images/location.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Live Tracking',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widgetPricolor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'With more than 1700 partners worldwide, ship anywhere in the world.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black38,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  'lib/resources/images/zones.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Zones',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widgetPricolor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Being mindful of safe zones and danger zones is essential for your safety.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  'lib/resources/images/zones.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Zones',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widgetPricolor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Being mindful of safe zones and danger zones is essential for your safety.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.white,
                ),
              ),
            ),
          ],
        ),)
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 216, 216),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: sourceLocation,
                zoom: 14.0,
              ),
              markers: {
                if (customMarker != null)
                  Marker(
                    markerId: MarkerId('source'),
                    position: sourceLocation,
                    icon: customMarker!,
                    infoWindow: InfoWindow(title: 'Source Location'),
                  ),
              },
              onMapCreated: (GoogleMapController controller) async {
                String style = '''
                [
                  {
                    "featureType": "poi.business",
                    "elementType": "labels",
                    "stylers": [
                      { "visibility": "off" }
                    ]
                  },
                  {
                    "featureType": "poi",
                    "elementType": "labels.text",
                    "stylers": [
                      { "visibility": "off" }
                    ]
                  }
                ]
                ''';
                controller.setMapStyle(style);
                _mapController.complete(controller);
              },
              mapToolbarEnabled: false, 
              zoomControlsEnabled: false, 
              myLocationEnabled: false, 
              myLocationButtonEnabled: false, 
              mapType: MapType.terrain,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 20,
                ),
                PreferredSize(
                  preferredSize: const Size.fromHeight(120.0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: TextField(
                                    controller: _textEditingController,
                                    focusNode: _focusNode,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '',
                                      hintStyle: TextStyle(
                                        color: Colors.transparent,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0), // Padding adjustment
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 12, 
                                  right: 12,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          FocusScope.of(context).requestFocus(_focusNode);
                                        }, 
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: AnimatedBuilder(
                                            animation: _controllerFade,
                                            builder: (context, child) {
                                              return Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Transform.translate(
                                                    offset: Offset(-5, -10), 
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      alignment: Alignment.center,
                                                      color: Colors.transparent,
                                                      child: SvgPicture.asset(
                                                        'lib/resources/svg/search.svg',
                                                        color: _colorAnimation.value,
                                                        height: 20,
                                                        width: 20,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(-5, 0), 
                                                    child: Text(
                                                      "Search for near",
                                                      style: TextStyle(
                                                        color: _colorAnimation.value,
                                                        fontSize: 13,
                                                      ),
                                                    )
                                                  )
                                                ]
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SlideTransition(
                                        position: _hintAnimation,
                                        child: AnimatedBuilder(
                                          animation: _hintColorAnimation,
                                          builder: (context, child) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context).requestFocus(_focusNode);
                                              },
                                              child: Text(
                                                hints[_currentHintIndex],
                                                style: TextStyle(
                                                  color: _hintColorAnimation.value, 
                                                  fontSize: 13,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap:(){},
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      color: Colors.transparent, 
                                      child: SvgPicture.asset(
                                        'lib/resources/svg/mic.svg',
                                        color: Colors.black87,
                                        height: 22, 
                                        width: 22,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Floating buttons
            widget.UserToken == 'guess'
              ? SizedBox()
              : Positioned(
                right: 20,
                bottom: 80,
                child: SizedBox(
                  width: 60,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push('/sos-page');
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child:
                              SvgPicture.asset("lib/resources/svg/connect.svg",
                              color: Colors.blue
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showCreateReportDialog(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "lib/resources/svg/dangerzone.svg",
                              color: widgetPricolor,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showMarkSafeDialog(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "lib/resources/svg/safezone.svg",
                              color: Colors.green
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCreateReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "lib/resources/svg/exclamation-mark.png",
                  width: 74,
                  height: 74,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Report an Incident",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Report any incidents or unsafe situations to help keep you and others safe",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Create Report",
                  onPressed: () {
                    context.push('/create-report');
                  },
                  width: 150,
                  height: 40,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMarkSafeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "lib/resources/svg/shield.png",
                  width: 74,
                  height: 74,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Mark this place safe",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure this location is safe? Marking it as safe will help others.",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Confirm Safe Zone",
                  onPressed: () {
                    context.push('/mark-safe-zone');
                  },
                  width: 150,
                  height: 40,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
