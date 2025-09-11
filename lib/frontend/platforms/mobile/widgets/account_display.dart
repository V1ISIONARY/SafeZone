import '../../../../../backend/properties/import.dart';

class AccountDisplay extends StatelessWidget {
  final String title;
  final String svgIcon;
  final String data;
  final VoidCallback? onTap;

  const AccountDisplay({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.data,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 25,
              margin: const EdgeInsets.only(right: 17),
              child: SvgPicture.asset(
                svgIcon,
                color: const Color.fromARGB(179, 0, 0, 0),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DescriptionText(text: title),
                PrimaryText(text: data),
              ],
            )
          ],
        ),
      ),
    );
  }
}
