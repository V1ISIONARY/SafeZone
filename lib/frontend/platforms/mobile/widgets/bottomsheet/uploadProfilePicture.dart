import 'package:safezone/backend/architecture/bloc/profileBloc/profile_bloc.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_event.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_state.dart';
import 'package:safezone/backend/properties/import.dart';

Future<void> showUploadPictureBottomSheet(
    BuildContext context, int user_id) async {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfilePictureUploading) {
            Navigator.of(context).pop(); // Close bottom sheet on upload start
          } else if (state is ProfilePictureUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Profile picture updated successfully')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
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

                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          titlePadding:
                              const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          title: const Text(
                            'Use this image?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(imageFile, height: 200),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Do you want to upload this as your profile picture?',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widgetPricolor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Upload'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        BlocProvider.of<ProfileBloc>(context).add(
                          UploadProfilePictureEvent(user_id, imageFile),
                        );
                      }
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
        ),
      );
    },
  );
}
