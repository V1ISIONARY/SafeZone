import '../../../../../backend/properties/import.dart';

class Contactinfo extends StatelessWidget {
  final String name;
  final String phone;

  const Contactinfo({super.key, required this.name, required this.phone});

  Future<void> _callNumber(String phone) async {
    final Uri uri =
        Uri.parse('tel:$phone'); 
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString()); 
    } else {
      throw 'Could not launch $uri'; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _callNumber(phone), 
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryText(text: name),
                  CategoryDescripText(text: phone)
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}
