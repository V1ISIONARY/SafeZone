import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/resources/schema/colors.dart' show widgetPricolor;
import 'package:safezone/resources/schema/texts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Experiment extends StatefulWidget {
  const Experiment({super.key});

  @override
  State<Experiment> createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late FocusNode _focusNodeText;
  late AnimationController _controller;
  late AnimationController _controllerFade;
  late TextEditingController _textEditingController;

  late stt.SpeechToText _speech;
  bool _isListening = false;

  late Animation<Offset> _hintAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _hintColorAnimation;

  int _currentHintIndex = 0;
  final List<String> hints = [
    'Barangay',
    'Hospital',
    'Police Station',
    'Municipal',
  ];

  @override
  void initState() {
    super.initState();

    _speech = stt.SpeechToText();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controllerFade = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _hintAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -2),
    ).animate(_controller);

    _hintColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.transparent, 
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.transparent,
    ).animate(_controllerFade);

    _focusNodeText = FocusNode();
    _textEditingController = TextEditingController();
    _changeHintText();

    _focusNodeText.addListener(() {
      if (_focusNodeText.hasFocus && _textEditingController.text.isEmpty) {
        _controllerFade.forward();
        _controller.forward();
      } else if (!_focusNodeText.hasFocus && _textEditingController.text.isEmpty) {
        _controller.reverse();
        _controllerFade.reverse();
      }
    });
  }

  void _changeHintText() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!_focusNodeText.hasFocus && _textEditingController.text.isEmpty) {
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
    _focusNodeText.dispose();
    _controller.dispose();
    _controllerFade.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: GestureDetector(
  //         onTap: () {
  //           if (!_isExpanded) {
  //             setState(() {
  //               _isExpanded = true;
  //             });
  //           }
  //         },
  //         child: LayoutBuilder(
  //           builder: (context, constraints) {
  //             return AnimatedContainer(
  //               duration: const Duration(milliseconds: 300),
  //               margin: const EdgeInsets.only(right: 10),
  //               width: _isExpanded ? 200 : 40, 
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(_isExpanded ? 20 : 50),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                     color: Colors.grey,
  //                     blurRadius: 2,
  //                     offset: Offset(1, 1),
  //                   ),
  //                 ],
  //               ),
  //               child: _isExpanded
  //                   ? Center(
  //                       child: SizedBox(
  //                         height: 40,
  //                         child: Container(
  //                           height: 40,
  //                           width: double.infinity,
  //                           decoration: const BoxDecoration(
  //                             color: Colors.grey,
  //                             borderRadius: BorderRadius.all(Radius.circular(20)),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.grey,
  //                                 blurRadius: 2,
  //                                 offset: Offset(1, 1),
  //                               ),
  //                             ],
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Expanded(
  //                                 child: Stack(
  //                                   children: [
  //                                     Positioned.fill(
  //                                       child: TextField(
  //                                         controller: _textEditingController,
  //                                         focusNode: _focusNodeText,
  //                                         style: GoogleFonts.poppins(
  //                                           fontSize: 9,
  //                                           fontWeight: FontWeight.w500,
  //                                           color: Colors.black,
  //                                         ),
  //                                         decoration: InputDecoration(
  //                                           filled: true,
  //                                           fillColor: Colors.white,
  //                                           hintText: '',
  //                                           hintStyle: const TextStyle(color: Colors.transparent),
  //                                           contentPadding: const EdgeInsets.only(left: 35, right: 40, bottom: 8),
  //                                           border: OutlineInputBorder(
  //                                             borderRadius: BorderRadius.circular(20.0),
  //                                             borderSide: const BorderSide(color: widgetPricolor),
  //                                           ),
  //                                           focusedBorder: OutlineInputBorder(
  //                                             borderRadius: BorderRadius.circular(20.0),
  //                                             borderSide: const BorderSide(color: widgetPricolor),
  //                                           ),
  //                                           enabledBorder: OutlineInputBorder(
  //                                             borderRadius: BorderRadius.circular(20.0),
  //                                             borderSide: const BorderSide(color: widgetPricolor),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Positioned(
  //                                       left: 0,
  //                                       child: Container(
  //                                         height: 40,
  //                                         width: 40,
  //                                         alignment: Alignment.center,
  //                                         child: SvgPicture.asset(
  //                                           'lib/resources/svg/search.svg',
  //                                           color: Colors.black,
  //                                           height: 20,
  //                                           width: 20,
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               GestureDetector(
  //                                 onTap: () {
  //                                   setState(() {
  //                                     _isExpanded = false;
  //                                     _textEditingController.clear();
  //                                     _focusNodeText.unfocus();
  //                                   });
  //                                 },
  //                                 child: Container(
  //                                   width: 40,
  //                                   height: 40,
  //                                   decoration: const BoxDecoration(
  //                                     color: Colors.grey,
  //                                     borderRadius: BorderRadius.only(
  //                                       bottomRight: Radius.circular(20),
  //                                       topRight: Radius.circular(20),
  //                                     ),
  //                                   ),
  //                                   child: Center(
  //                                     child: ValueListenableBuilder<TextEditingValue>(
  //                                       valueListenable: _textEditingController,
  //                                       builder: (context, value, child) {
  //                                         return Transform.translate(
  //                                           offset: Offset(-3.2, 0),
  //                                           child: Icon(
  //                                             value.text.isNotEmpty ? Icons.send : Icons.close,
  //                                             color: Colors.white,
  //                                             size: 18,
  //                                           ),
  //                                         );
  //                                       },
  //                                     ),
  //                                   ),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : const Icon(Icons.search, color: Colors.green, size: 20),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey,
    body: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey,
        ),
      ],
    ),
    bottomNavigationBar: BottomAppBar(
      shape: const CircularNotchedRectangle(), // Notched shape for FAB
      notchMargin: 6.0, // Space between FAB and BottomAppBar
      clipBehavior: Clip.antiAlias, // Ensures the notch is smooth
      child: SizedBox(
        height: 65, // Proper height for the notch to be visible
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 17,
                    child: SvgPicture.asset(
                      'lib/resources/svg/map.svg',
                      color: widgetPricolor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Map',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: widgetPricolor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()), // Leaves space for FAB notch
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: widgetPricolor,
      splashColor: Colors.transparent,
      elevation: 5,
      shape: const CircleBorder(), // Ensures the FAB is circular
      onPressed: () {
        context.push('/sos-countdown');
      },
      child: const Text(
        'SOS',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Places the FAB inside the notch
  );
}


}