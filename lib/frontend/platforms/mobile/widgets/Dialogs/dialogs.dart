import '../../../../../backend/properties/import.dart';

void showCreateReportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "lib/resource/svg/exclamation-mark.png",
                width: 74,
                height: 74,
              ),
              const SizedBox(height: 10),
              const CategoryText(text: "Report an Incident"),
              const SizedBox(height: 5),
              const CategoryDescripText(
                  text:
                      "Report any incidents or unsafe situations to help keep you\nand others safe",
                  alignment: 'center'),
              const SizedBox(height: 20),
              CustomButton(
                text: "Create Report",
                onPressed: () {
                  context.push('/create-report');
                  Navigator.pop(context);
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

void showMarkSafeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "lib/resource/svg/shield.png",
                width: 74,
                height: 74,
              ),
              const SizedBox(height: 10),
              const CategoryText(text: "Mark this place safe"),
              const SizedBox(height: 5),
              const CategoryDescripText(
                text:
                    "Are you sure this location is safe? Marking it as safe\nwill help others.",
                alignment: "center",
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Create safe zone",
                onPressed: () {
                  context.push('/mark-safe-zone');
                  Navigator.pop(context);
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
