import 'package:safezone/backend/architecture/bloc/profileBloc/profile_bloc.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_event.dart';
import 'package:safezone/backend/properties/import.dart';

void showUploadPictureBottomSheet(BuildContext context, int user_id) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: widgetPricolor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              GestureDetector(
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final imageFile = File(pickedFile.path);

                    final int userId = user_id;

                    // Dispatch the event to the bloc
                    BlocProvider.of<ProfileBloc>(context).add(
                      UploadProfilePictureEvent(userId, imageFile),
                    );

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('profile_picture',
                        "https://storage.googleapis.com/safezone-11724.firebasestorage.app/profile_pictures/${imageFile.path}");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 245, 245, 245),
                        ),
                        child: const Icon(
                          size: 24,
                          Icons.image,
                          color: widgetPricolor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Choose profile picture',
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      );
    },
  );
}
