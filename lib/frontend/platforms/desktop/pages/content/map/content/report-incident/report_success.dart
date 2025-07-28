import 'package:safezone/backend/properties/import.dart';

class ReportSuccessDT extends StatefulWidget {

  final VoidCallback? onGoToReports;
  final VoidCallback? onClose;
  final VoidCallback? onBack;
  const ReportSuccessDT({
    super.key,
    this.onBack,
    this.onClose,
    this.onGoToReports
  });

  @override
  State<ReportSuccessDT> createState() => _ReportSuccessDTState();
}

class _ReportSuccessDTState extends State<ReportSuccessDT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
                child: Column(
                  children: [
                    Image.asset(
                      "lib/resource/svg/success.png",
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Thank you for sharing! Your report helps protect women and keep our community safe. We truly appreciate your effort in making the world a safer place for everyone.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
                  ]
                )
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.8,
                child: Column(
                  children: [
                    CustomButton(
                      widthSize: true,
                      text: "Go to reports history",
                      buttonColor: widgetPricolor,
                      onPressed: (){
                        widget.onClose?.call();
                        widget.onGoToReports?.call();
                      }
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      widthSize: true,
                      isOutlined: true,
                      text: "Report again?",
                      textColor: widgetPricolor,
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userToken = prefs.getString('userToken'); 
                        if (userToken != null) {
                          widget.onBack?.call();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("User token not found! Please log in again."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    ),
                  ]
                )
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      )
    );
  }
}
