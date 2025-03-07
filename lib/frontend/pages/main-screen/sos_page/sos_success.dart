import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class SosSuccess extends StatefulWidget {
  const SosSuccess({super.key});

  @override
  State<SosSuccess> createState() => _SosSuccessState();
}

class _SosSuccessState extends State<SosSuccess> {
  @override
  void initState() {
    super.initState();
    _sendBroadcastNotification();
  }

  Future<void> _sendBroadcastNotification() async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('id') ?? 0;
    String firstName = prefs.getString('first_name') ?? "User";
    String lastName = prefs.getString('last_name') ?? "";

    final formattedFirstName = firstName.isNotEmpty
        ? firstName[0].toUpperCase() + firstName.substring(1).toLowerCase()
        : '';
    final formattedLastName = lastName.isNotEmpty
        ? lastName[0].toUpperCase() + lastName.substring(1).toLowerCase()
        : '';
    String fullName = "$formattedFirstName $formattedLastName".trim();

    if (userId != 0) {
      context.read<NotificationBloc>().add(
            BroadcastNotification(
                userId, // Use the stored user ID
                "Emergency Alert",
                "$fullName has triggered an SOS alert!",
                "SOS"),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: User ID not found!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "SOS Sent"),
      ),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationBroadcasted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("SOS notification broadcasted!")));
          } else if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.message}")));
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                Image.asset(
                  "lib/resources/svg/sos-success.png",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 30),
                const Text(
                  "SOS sent!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Your circle and emergency contacts have been notified.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
                const Spacer(),
                CustomButton(
                  text: "Back to Home",
                  isOutlined: true,
                  onPressed: () {
                    context.push('/');
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
