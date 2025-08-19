import '../../../../../backend/properties/import.dart';

class Userinfomartion extends StatelessWidget {
  final String username;
  final String profileImage;
  final int safeZone;
  final int incidents;
  const Userinfomartion(
      {super.key,
      required this.username,
      required this.profileImage,
      required this.safeZone,
      required this.incidents});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(10, 0, 0, 0),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 15),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: profileImage.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey,
                        ),
                      )
                    : Image.network(
                        profileImage,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryText(text: username),
                    CategoryDescripText(
                        text:
                            'SafeZone: $safeZone ⋅ Incident Reports: $incidents')
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
