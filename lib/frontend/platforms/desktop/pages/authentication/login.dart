// ignore_for_file: prefer_const_constructors
import 'package:safezone/frontend/root/content/navigation.dart';

import '../../../../../backend/architecture/bloc/authBloc/auth_bloc.dart';
import '../../../../../backend/architecture/bloc/authBloc/auth_event.dart';
import '../../../../../backend/architecture/bloc/authBloc/auth_state.dart';
import '../../../../../backend/architecture/bloc/notificationBloc/notification_polling.dart';
import '../../../../../backend/properties/import.dart';
import '../../../../../backend/properties/properties.dart';

class LoginDesktop extends StatefulWidget {
  const LoginDesktop({
    super.key,
  });

  @override
  State<LoginDesktop> createState() => _LoginDesktopState();
}

class _LoginDesktopState extends State<LoginDesktop> {
  final NotificationPollingService _pollingService =
      NotificationPollingService();
  final sharedController = SharedProperties();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'lib/resource/image/logo/safezone.png',
                height: 20,
                width: 18,
              ),
              SizedBox(width: 5),
              CategoryText(text: 'Safezone')
            ],
          ),
          SizedBox(height: 30),
          Text(
            'Log in to your Account',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          ),
          SizedBox(height: 5),
          Text(
            'Welcome back! Select method to log in:',
            style: TextStyle(color: Colors.black54, fontSize: 10),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/resource/image/logo/google.png',
                      height: 18,
                      width: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Google',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13),
                    )
                  ],
                ),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/resource/image/logo/facebook.png',
                      height: 18,
                      width: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Facebook',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13),
                    )
                  ],
                ),
              )),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Divider(
                height: 0.5,
                color: Colors.black12,
              )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('or continue with email',
                      style: TextStyle(color: Colors.black38, fontSize: 10))),
              Expanded(
                  child: Divider(
                height: 0.5,
                color: Colors.black12,
              ))
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: sharedController.emailController,
            cursorColor: labelFormFieldColor,
            style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w100),
            decoration: InputDecoration(
                hintText: "safezone@gmail.com",
                hintStyle: TextStyle(
                    fontSize: 12,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w100),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black12)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black12, width: 2)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(Icons.email_outlined,
                      color: sharedController.emailController.text.isNotEmpty
                          ? widgetPricolor
                          : Colors.black26),
                )),
            onChanged: (text) {
              setState(() {});
            },
          ),
          SizedBox(height: 10),
          TextField(
            cursorColor: labelFormFieldColor,
            controller: sharedController.passwordController,
            obscureText: !sharedController.passwordVisible,
            style: TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w100),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: "exampl*******",
                hintStyle: TextStyle(
                    fontSize: 12,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w100),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black12)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black12, width: 2)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.lock_outline,
                      color: sharedController.passwordController.text.isNotEmpty
                          ? widgetPricolor
                          : Colors.black26),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        sharedController.passwordVisible =
                            !sharedController.passwordVisible;
                      });
                    },
                    child: Icon(
                      sharedController.passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Color(0xFF707070),
                    ),
                  ),
                )),
            onChanged: (text) {
              setState(() {});
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: sharedController.rememberMe,
                    onChanged: (value) {
                      setState(() {
                        sharedController.rememberMe = value!;
                      });
                    },
                    side: BorderSide(
                      color: Color(0x99EF8D88),
                      width: 2,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    activeColor: widgetPricolor,
                  ),
                  Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF707070),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: widgetPricolor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(onTap: () {
            final email = sharedController.emailController.text;
            final password = sharedController.passwordController.text;
            context.read<AuthenticationBloc>().add(UserLogin(email, password));
          }, child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            return Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widgetPricolor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: state is LoginLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 1)),
                      )
                    : Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          })),
          SizedBox(height: 25),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account yet?",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: GestureDetector(
                      onTap: () {
                        sharedController.authenticationPage.value = false;
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: widgetPricolor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) async {
              if (state is LoginSuccess) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                int userId = prefs.getInt('id') ?? 0;
                await prefs.setString('userToken', userId.toString());

                if (userId != 0) {
                  int intervalInSeconds = 10;
                  _pollingService.startPolling(userId, intervalInSeconds);
                }

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        NavigationRT(userToken: userId.toString()),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );

                print(state);
              } else if (state is LoginError) {
                print(state.message);
              }
            },
            child: Container(),
          )
        ],
      ),
    );
  }
}
