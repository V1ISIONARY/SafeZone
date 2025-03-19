import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/mapBloc/map_bloc.dart';
import 'package:safezone/backend/bloc/mapBloc/map_event.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkSafeSuccess extends StatefulWidget {
  const MarkSafeSuccess({super.key});

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
              Image.asset(
                "lib/resources/svg/success.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 50),
              const Text(
                "Thank you for helping keep the community safe! Your safe zone submission is under review and will be verified shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const Spacer(),
              CustomButton(
                text: "Go to your safezone history",
                widthSize: true,
                buttonColor: widgetPricolor,
                onPressed: () {
                  context.go('/safezone-history', extra: true);
                }
              ),
              const SizedBox(height: 10),
              CustomButton(
                widthSize: true,
                text: "Back to Home",
                textColor: widgetPricolor,
                buttonColor: widgetPricolor,
                isOutlined: true,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final userToken = prefs.getString('userToken'); 
                  if (userToken != null) {
                    context.go('/home', extra: userToken);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User token not found! Please log in again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  context.read<MapBloc>().add(FetchMapData());
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
