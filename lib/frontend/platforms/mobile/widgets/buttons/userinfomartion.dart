import '../../../../../backend/properties/import.dart';

class Userinfomartion extends StatelessWidget {
  final int userid;
  final String username;
  final bool activity_status;
  final String profileImage;
  final int safeZone;
  final int incidents;
  final VoidCallback onToggleStatus; // ✅ callback for toggle button

  const Userinfomartion({
    super.key,
    required this.username,
    required this.userid,
    required this.activity_status,
    required this.profileImage,
    required this.safeZone,
    required this.incidents,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Profile Picture
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(left: 15),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: profileImage.isEmpty
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
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

          // Text Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryText(text: username),
                  Text.rich(
                    TextSpan(
                      text:
                          'SafeZone: $safeZone ⋅ Reports: $incidents | Status: ',
                      style: const TextStyle(fontSize: 12),
                      children: [
                        TextSpan(
                          text: activity_status ? 'Active' : 'Deactivated',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: activity_status ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Action Button on the Right
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: ElevatedButton(
              onPressed: onToggleStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: activity_status ? Colors.red : Colors.green,
                minimumSize: const Size(90, 35),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                activity_status ? 'Deactivate' : 'Activate',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
