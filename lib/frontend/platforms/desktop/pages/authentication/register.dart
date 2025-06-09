// ignore_for_file: prefer_const_constructors
import '../../../../../backend/properties/import.dart';
import '../../../../../backend/properties/properties.dart';

class RegisterDesktop extends StatefulWidget {
  const RegisterDesktop({super.key});

  @override
  State<RegisterDesktop> createState() => _RegisterDesktopState();
}

class _RegisterDesktopState extends State<RegisterDesktop> {
  TextEditingController ageController = TextEditingController();
  final sharedController = SharedProperties();
  String? genderOption; 

  final List<String> dropdownItems = [
    "Male",
    "Female"
  ];
  
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
                'lib/resource/image/png/email.png',
                height: 20,
                width: 18,
              ),
              SizedBox(width: 5),
              CategoryText(text: 'Safezone')
            ],
          ),
          SizedBox(height: 30),
          Text(
            'Sign up to your Account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Welcome back! Select method to log in:',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 10
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  cursorColor: labelFormFieldColor,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w100
                  ),
                  decoration: InputDecoration(
                    hintText: "First Name",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: labelFormFieldColor,
                      fontWeight: FontWeight.w100
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black12)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black12, width: 2)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widgetPricolor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 12
                    )
                  )
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  cursorColor: labelFormFieldColor,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w100
                  ),
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: labelFormFieldColor,
                      fontWeight: FontWeight.w100
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black12)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black12, width: 2)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widgetPricolor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 12
                    ),
                  )
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          TextField(
            cursorColor: labelFormFieldColor,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w100
            ),
            decoration: InputDecoration(
              hintText: "alexander",
              hintStyle: TextStyle(
                fontSize: 12,
                color: labelFormFieldColor,
                fontWeight: FontWeight.w100
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black12)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black12, width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widgetPricolor, width: 2),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 12
              ),
              prefixIcon: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.person_2_outlined, color: Colors.black26),
              )
            ),
          ),
          SizedBox(height: 20),
          TextField(
            cursorColor: labelFormFieldColor,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w100
            ),
            decoration: InputDecoration(
              hintText: "safezone@gmail.com",
              hintStyle: TextStyle(
                fontSize: 12,
                color: labelFormFieldColor,
                fontWeight: FontWeight.w100
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black12)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black12, width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widgetPricolor, width: 2),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 12
              ),
              prefixIcon: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.email_outlined, color: Colors.black26),
              )
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: ageController,
                    cursorColor: labelFormFieldColor,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w100,
                    ),
                    decoration: InputDecoration(
                      hintText: "Age",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: labelFormFieldColor,
                        fontWeight: FontWeight.w100,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: genderOption,
                      hint: Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 12,
                          color: labelFormFieldColor,
                          fontWeight: FontWeight.w100
                        ),
                      ),
                      items: dropdownItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w100
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          genderOption = newValue;
                        });
                      },
                      dropdownColor: Colors.white,
                      isExpanded: true, 
                    ),
                  ),
                )
              ),
            ],
          ),
          SizedBox(height: 20),
          // TextField(
          //   cursorColor: labelFormFieldColor,
          //   controller: sharedController.passwordController,
          //   obscureText: !sharedController.passwordVisible,
          //   style: TextStyle(
          //     fontSize: 12,
          //     color: Colors.black,
          //     fontWeight: FontWeight.w100
          //   ),
          //   decoration: InputDecoration(
          //     filled: true,
          //     fillColor: Colors.transparent,
          //     hintText: "exampl*******",
          //     hintStyle: TextStyle(
          //       fontSize: 12,
          //       color: labelFormFieldColor,
          //       fontWeight: FontWeight.w100
          //     ),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8),
          //       borderSide: BorderSide(color: Colors.black12)
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8),
          //       borderSide: BorderSide(color: Colors.black12, width: 2)
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8),
          //       borderSide: BorderSide(color: widgetPricolor, width: 2),
          //     ),
          //     contentPadding: const EdgeInsets.symmetric(
          //       horizontal: 15, vertical: 12
          //     ),
          //     prefixIcon: Container(
          //       margin: EdgeInsets.only(left: 10),
          //       child: Icon(Icons.lock_outline, color: Colors.black26),
          //     ),
          //     suffixIcon: Padding(
          //       padding: EdgeInsets.only(right: 10),
          //       child: GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             sharedController.passwordVisible = !sharedController.passwordVisible;
          //           });
          //         },
          //         child: Icon(
          //           sharedController.passwordVisible
          //               ? Icons.visibility_outlined
          //               : Icons.visibility_off_outlined,
          //           color: Color(0xFF707070),
          //         ),
          //       ),
          //     )
          //   ),
          // ),
          // SizedBox(height: 20),
          GestureDetector(
            onTap: (){},
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widgetPricolor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12
                  ),
                ),
              ),
            ),
          ),
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
                        setState(() {
                          sharedController.authenticationPage.value = true;
                        });
                      },
                      child: Text(
                        "Sign In",
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
        ],
      ),
    );
  }
}