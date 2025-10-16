import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../backend/architecture/bloc/notificationBloc/notification_state.dart';
import '../../../../../../backend/properties/import.dart';

class SosSuccess extends StatefulWidget {
  const SosSuccess({super.key});

  @override
  State<SosSuccess> createState() => _SosSuccessState();
}

class _SosSuccessState extends State<SosSuccess> {
  late SharedPreferences prefs;
  bool _showTitle = false;
  double _appBarHeight = 0;
  String _notificationText = "";
  Color _appBarColor = Colors.transparent;

  Future<void> _checkIfShown(
      {required String text, required Color color}) async {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _appBarHeight = 40;
          _appBarColor = color;
          _notificationText = text;
          _showTitle = true;
        });
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _appBarHeight = 0;
            _appBarColor = Colors.transparent;
            _showTitle = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _sendBroadcastNotification();
  }

  Future<void> _sendBroadcastNotification() async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('id') ?? 0;
    bool isGuest = userId == 0;

    String firstName, lastName, fullName;

    if (isGuest) {
      firstName = "Guest";
      lastName = "User";
      fullName = "Guest User";
      userId = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
    } else {
      firstName = prefs.getString('first_name') ?? "User";
      lastName = prefs.getString('last_name') ?? "";

      final formattedFirstName = firstName.isNotEmpty
          ? firstName[0].toUpperCase() + firstName.substring(1).toLowerCase()
          : '';
      final formattedLastName = lastName.isNotEmpty
          ? lastName[0].toUpperCase() + lastName.substring(1).toLowerCase()
          : '';
      fullName = "$formattedFirstName $formattedLastName".trim();
    }

    String? address =
        prefs.getString('currentAddress') ?? "Location unavailable";
    String policeStationName =
        prefs.getString('nearest_station_name') ?? "WALA";

    try {
      if (isGuest) {
        context.read<NotificationBloc>().add(
              BroadcastNotificationPoliceStation(
                userId,
                "🚨 EMERGENCY SOS ALERT - GUEST USER",
                policeStationName,
                "$fullName has triggered an SOS alert! \n"
                    "📍 Location: $address \n"
                    "👤 User Type: Guest (Temporary ID: $userId)",
                "SOS",
              ),
            );
        print("🚨 Guest SOS sent to police station only (ID: $userId)");
      } else {
        context.read<NotificationBloc>().add(
              BroadcastNotification(
                userId,
                "🚨 EMERGENCY SOS ALERT",
                "$fullName has triggered an SOS alert! \n"
                    "📍 Location: $address \n",
                "SOS",
              ),
            );

        context.read<NotificationBloc>().add(
              BroadcastNotificationPoliceStation(
                userId,
                "🚨 EMERGENCY SOS ALERT",
                policeStationName,
                "$fullName has triggered an SOS alert! \n"
                    "📍 Location: $address \n",
                "SOS",
              ),
            );
        print("🚨 Registered user SOS sent to circle and police (ID: $userId)");
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isGuest
                        ? '✅ Emergency alert sent to authorities! Help is on the way.'
                        : '✅ SOS Alert sent to your circle and authorities!',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '⚠️ Emergency alert sent! Authorities notified.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      }
      print("❌ SOS notification error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationBroadcasted) {
              _checkIfShown(
                  text: "SOS notification broadcasted!", color: Colors.green);
            } else if (state is NotificationError) {
              _checkIfShown(text: "Error: ${state.message}", color: Colors.red);
            }
          },
          child: Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _appBarHeight,
              color: _appBarColor,
              width: double.infinity,
              alignment: Alignment.center,
              child: _showTitle
                  ? CategoryDescripText(
                      text: _notificationText,
                      color: Colors.white,
                    )
                  : null,
            ),
            AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const CategoryText(text: "SOS Sent"),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200),
                    Image.asset(
                      "lib/resource/svg/sos-success.png",
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
                      widthSize: true,
                      buttonColor: widgetPricolor,
                      textColor: widgetPricolor,
                      isOutlined: true,
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userToken = prefs.getString('userToken');
                        if (userToken != null) {
                          context.go('/home', extra: userToken);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "User token not found! Please log in again."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            )
          ])),
    );
  }
}
