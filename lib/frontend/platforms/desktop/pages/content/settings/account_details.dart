import 'package:safezone/backend/architecture/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_bloc.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_state.dart';
import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/bottomsheet/uploadProfilePicture.dart';

class AccountDetails extends StatefulWidget {
  final VoidCallback? onClose;
  const AccountDetails({this.onClose, super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  String username = '';
  int user_id = 0;
  String email = '';
  String profilePictureUrl = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String password = '';
  String address = '';
  bool isAdmin = false;
  bool isGirl = false;
  bool isVerified = false;

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      user_id = prefs.getInt('id') ?? 0;
      password = prefs.getString('password') ?? '*****';
      phone = prefs.getString('phone') ?? 'Phone Number not set';
      email = prefs.getString('email') ?? 'user@example.com';
      profilePictureUrl = prefs.getString('profile_picture_url') ??
          'https://storage.googleapis.com/safezone-11724.firebasestorage.app/profile_pictures/2.jpg';
      firstName = prefs.getString('first_name') ?? 'First Name';
      lastName = prefs.getString('last_name') ?? 'Last Name';
      address = prefs.getString('address') ?? 'Address not set';
      isAdmin = prefs.getBool('is_admin') ?? false;
      isGirl = prefs.getBool('is_girl') ?? false;
      isVerified = prefs.getBool('is_verified') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> _openProfilePictureBottomSheet() async {
    await showUploadPictureBottomSheet(context, user_id);
    await loadUserData(); // Force refresh
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController =
        TextEditingController();

    bool showCurrentPassword = false;
    bool showNewPassword = false;
    bool showConfirmPassword = false;
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPasswordField(
                      controller: currentPasswordController,
                      label: "Current Password",
                      obscureText: !showCurrentPassword,
                      onToggle: () {
                        setState(() {
                          showCurrentPassword = !showCurrentPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: newPasswordController,
                      label: "New Password",
                      obscureText: !showNewPassword,
                      onToggle: () {
                        setState(() {
                          showNewPassword = !showNewPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: confirmNewPasswordController,
                      label: "Confirm New Password",
                      obscureText: !showConfirmPassword,
                      onToggle: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: textColor, fontSize: 13),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widgetPricolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    String currentPassword = currentPasswordController.text;
                    String newPassword = newPasswordController.text;
                    String confirmNewPassword =
                        confirmNewPasswordController.text;

                    if (currentPassword.isEmpty ||
                        newPassword.isEmpty ||
                        confirmNewPassword.isEmpty) {
                      setState(() {
                        errorMessage = 'All fields are required.';
                      });
                    } else if (newPassword != confirmNewPassword) {
                      setState(() {
                        errorMessage = 'New passwords do not match.';
                      });
                    } else if (newPassword.length < 8) {
                      setState(() {
                        errorMessage =
                            'Password must be at least 8 characters.';
                      });
                    } else {
                      context.read<AuthenticationBloc>().add(
                            ChangePasswordEvent(
                              password: currentPassword,
                              newPassword: newPassword,
                            ),
                          );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 11),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 11, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfilePictureUploaded) {
          loadUserData();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Transform.translate(
              offset: const Offset(0, 0),
              child: const CategoryText(text: "Account Details")),
          actions: [
            GestureDetector(
                onTap: () {
                  if (widget.onClose != null) {
                    widget.onClose!();
                  }
                },
                child: const Icon(
                  Icons.cancel_outlined,
                  size: 20,
                  color: Colors.black38,
                )),
            SizedBox(width: 10)
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 250, 250),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          final isUploading = state is ProfilePictureUploading;

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Colors.black38,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: profilePictureUrl.isNotEmpty
                                      ? Image.network(
                                          profilePictureUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'lib/resource/image/jpg/profile.jpg',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'lib/resource/image/jpg/profile.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              if (isUploading)
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _openProfilePictureBottomSheet(),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      CategoryText(text: "$firstName $lastName"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 13,
                            height: 13,
                            child: SvgPicture.asset(
                              'lib/resource/svg/verified.svg',
                              color: widgetPricolor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const CategoryDescripText(
                              text: "Verified at Safezone"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Credentials Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      const CategoryText(text: 'Credentials'),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => _showChangePasswordDialog(context),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              'lib/resource/svg/edit.svg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Display Credentials Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 250, 250),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountDisplay(
                        title: "Password",
                        svgIcon: "lib/resource/svg/password.svg",
                        data: password,
                      ),
                      const Divider(height: 0.5, color: Colors.white),
                      // AccountDisplay(
                      //   title: "Phone",
                      //   svgIcon: "lib/resource/svg/phone.svg",
                      //   data: phone,
                      // ),
                      // Divider(height: 0.5, color: Colors.white),
                      AccountDisplay(
                        title: "Email",
                        svgIcon: "lib/resource/svg/mail.svg",
                        data: email,
                      ),
                      const Divider(height: 0.5, color: Colors.white),
                      AccountDisplay(
                        title: "Location",
                        svgIcon: "lib/resource/svg/location.svg",
                        data: address,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
