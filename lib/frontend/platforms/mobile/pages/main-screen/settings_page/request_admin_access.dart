
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_state.dart';
import '../../../../../../backend/architecture/bloc/profileBloc/profile_bloc.dart';
import '../../../../../../backend/architecture/bloc/profileBloc/profile_event.dart';
import '../../../../../../backend/properties/import.dart';

class RequestAdminAccessPage extends StatefulWidget {
  const RequestAdminAccessPage({super.key});

  @override
  State<RequestAdminAccessPage> createState() => _RequestAdminAccessPageState();
}

class _RequestAdminAccessPageState extends State<RequestAdminAccessPage> {
  final TextEditingController reasonController = TextEditingController();
  int _userId = 0;

  bool _showTitle = false;
  double _appBarHeight = 0;
  String _notificationText = "";
  Color _appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('id') ?? 0;
    });
  }

  void _checkIfShown({required String text, required Color color}) {
    setState(() {
      _appBarHeight = 40;
      _appBarColor = color;
      _showTitle = true;
      _notificationText = text;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _appBarHeight = 0;
          _appBarColor = Colors.transparent;
          _showTitle = false;
        });
      }
    });
  }

  void _submitRequest(BuildContext context) {
    if (_userId == 0) {
      _checkIfShown(
        text: "User not found. Please try again.",
        color: Colors.red,
      );
      return;
    }

    if (reasonController.text.isEmpty) {
      _checkIfShown(
        text: "Please provide a reason for your request",
        color: Colors.orange,
      );
      return;
    }

    context.read<ProfileBloc>().add(RequestAdminAccess(_userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is AdminAccessRequestSuccess) {
          _checkIfShown(
            text: state.message,
            color: Colors.green,
          );

          // Navigate back after successful submission
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else if (state is AdminAccessRequestError) {
          _checkIfShown(
            text: state.error,
            color: Colors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          automaticallyImplyLeading: false,
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
              child:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 10),
            ),
          ),
          title: const CategoryText(text: "Request Admin Access"),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    // Notification Banner
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _appBarHeight,
                      color: _appBarColor,
                      child: _showTitle
                          ? Center(
                              child: Text(
                                _notificationText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "Admins have additional permissions such as approving reports and managing safe zones.\n\n"
                                "If you need admin access, please submit a request. An existing admin will review it.",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: reasonController,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w200,
                                color: textColor,
                              ),
                              decoration: InputDecoration(
                                hintText: "Reason for requesting admin access",
                                hintStyle: const TextStyle(
                                  fontSize: 11,
                                  color: labelFormFieldColor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: widgetPricolor, width: 2),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: GestureDetector(
                                onTap: () {
                                  _submitRequest(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: widgetPricolor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: state is AdminAccessRequestLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Submit Request',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
