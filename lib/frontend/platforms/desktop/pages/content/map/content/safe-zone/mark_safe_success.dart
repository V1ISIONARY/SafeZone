import 'package:flutter/material.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/buttons/custom_button.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkSafeSuccess extends StatefulWidget {
  final VoidCallback? onGoToSZ;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  const MarkSafeSuccess({
    super.key,
    this.onBack,
    this.onClose,
    this.onGoToSZ,
  });

  @override
  State<MarkSafeSuccess> createState() => _MarkSafeSuccessState();
}

class _MarkSafeSuccessState extends State<MarkSafeSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              Transform.scale(
                  scale: 0.8,
                  child: Column(children: [
                    Image.asset(
                      "lib/resource/svg/success.png",
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Thank you for helping keep the community safe! Your safe zone submission is under review and will be verified shortly.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
                  ])),
              const Spacer(),
              Transform.scale(
                  scale: 0.8,
                  child: Column(children: [
                    CustomButton(
                        text: "Go to your safezone history",
                        widthSize: true,
                        buttonColor: widgetPricolor,
                        onPressed: () {
                          widget.onGoToSZ?.call();
                          widget.onClose?.call();
                        }),
                    const SizedBox(height: 10),
                    CustomButton(
                      widthSize: true,
                      text: "Mark Safezone Again?",
                      textColor: widgetPricolor,
                      buttonColor: widgetPricolor,
                      isOutlined: true,
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userToken = prefs.getString('userToken');
                        if (userToken != null) {
                          widget.onBack?.call();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "User token not found! Please log in again."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        // context.read<MapBloc>().add(FetchMapData());
                      },
                    ),
                  ])),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
