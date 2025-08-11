import 'package:safezone/frontend/platforms/mobile/widgets/buttons/sos_button.dart';

import '../../../../../../backend/properties/import.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});
  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
          ),
        ),
        title: const CategoryText(text: "SOS"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tap or hold to send SOS",
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  context.push('/sos-countdown');
                },
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: SosButton(), // TODO: fix render issue
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                "Your SOS will be sent to your trusted circle. Check who’s in your circles",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
