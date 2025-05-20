import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/screens/auth_module/profile_bottom_sheet.dart';
import 'package:my_di_card/screens/auth_module/signup_bottom_sheet.dart';
import 'package:my_di_card/screens/home_module/first_card.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:provider/provider.dart';

import '../../language/app_localizations.dart';
import '../../language/locale_constant.dart';
import '../../notifire_class.dart';
import '../../utils/widgets/button_primary.dart';
import '../home_module/main_home_page.dart';
import 'login_bottom_sheet.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? _selectedLanguage;

  final List<Map<String, String>> countries = [
    {"flag": "🇺🇸", "country": "English", "language": "English"},
    {"flag": "🇫🇷", "country": "France", "language": "Français"},
  ];

  List<String> imageList = [
    "assets/images/Frame 1000001118.png",
    "assets/logo/french.png",
  ];

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        checkLoginStatus();
      },
    );
    super.initState();
  }

  void checkLoginStatus() async {
    var token = await Storage().getToken();
    var isFirstCardSkip = await Storage().getFirstCardSkip();
    if (token.isNotEmpty) {
      print("isFirstCardSkip>>>>$isFirstCardSkip");

      final loginUser = await Storage().getUserFromPreferences();

      if (loginUser != null && loginUser.firstName == null) {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          isScrollControlled: true,
          useRootNavigator: false,
          enableDrag: false,
          isDismissible: false,
          builder: (context) => ProfileBottomSheet(),
        );
      }else if (!isFirstCardSkip) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (builder) => FirstCardScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (builder) => BottomNavBarExample()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 3, 36),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
          "assets/images/Top with a picture.png",
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Text
            const SizedBox(
              height: 80,
            ),

            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (builder) => WelcomePage()),
                  (route) => false,
                );
              },
              child: Text(AppLocalizations.of(context).translate('welcome'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                child: Image.asset(
              "assets/images/image 22.png",
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height / 2.8,
            )),

            // Illustration or Icon (Optional)

            // Get Started Button
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 340,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 50),
              child: Text(
                "Create and share digital cards!",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 30, top: 30),
              child: Utils().primaryButton(
                  onClick: () {
                    showModalBottomSheet(
                      context: context,
                      enableDrag: false,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, setState) =>
                              _buildLanguageSelectionSheet(context, setState),
                        );
                      },
                    );
                  },
                  colors: ColoursUtils.primaryColor,
                  text: AppLocalizations.of(context).translate('start')),
            ),
          ],
        ),
      ),
    );
  }

  int selectedIndex = 0;

  Widget _buildLanguageSelectionSheet(BuildContext context, newSetState) {
    return Container(
      padding: const EdgeInsets.all(16),
      height:
          MediaQuery.of(context).size.height / 2.2, // Adjust height as needed
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.grey[300],
            height: 3,
            width: 66,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
          Text(
            AppLocalizations.of(context).translate('select'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // const Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                Color borderColor = Colors.grey;

                return GestureDetector(
                  onTap: () {
                    newSetState(() {
                      borderColor = Colors.blue;
                      selectedIndex = index;
                      if (index == 0) {
                        final langNotifier = Provider.of<LocalizationNotifier>(context, listen: false);
                        langNotifier.setAppLocal(Locale("en"));
                        Storage().setLanguage("en");
                      } else {
                        final langNotifier = Provider.of<LocalizationNotifier>(context, listen: false);
                        langNotifier.setAppLocal(Locale("fr"));
                        Storage().setLanguage("fr");
                     }
                    });
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: selectedIndex == index
                              ? Colors.blue
                              : borderColor,
                          width: selectedIndex == index ? 1 : 0.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 12, right: 12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          imageList[index].toString(),
                          height: 40.0,
                          fit: BoxFit.cover,
                          width: 40.0,
                        ),
                      ),
                      title: Text(
                        countries[index]['country']!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        "(${countries[index]['language']!})",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800]),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 2,
            ),
          ),
          const SizedBox(height: 10),
          Utils().primaryButton(
              onClick: () {
                Navigator.pop(context); // Close the bottom sheet

                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  isScrollControlled: true, // To allow full height usage
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: LoginSignUpBottomSheetContent(),
                    );
                  },
                );
              },
              colors: ColoursUtils.primaryColor.withOpacity(0.8),
              text: AppLocalizations.of(context).translate('next')),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class LoginSignUpBottomSheetContent extends StatelessWidget {
  const LoginSignUpBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Login and Sign Up
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tab bar with "Login" and "Sign Up"
              Container(
                color: Colors.grey[300],
                height: 3,
                width: 66,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),

              Container(
                margin: const EdgeInsets.all(
                    16), // Optional margin around the tab bar
                width: double.infinity, // Full width of the screen
                decoration: BoxDecoration(
                  border: Border.all(
                      color: ColoursUtils.background,
                      width: 3), // Outline border
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: TabBar(
                  tabAlignment: TabAlignment.fill,

                  automaticIndicatorColorAdjustment: true,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  unselectedLabelColor: Colors.black, // Inactive label color
                  isScrollable:
                      false, // Disables scrolling, makes the tabs equal width
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  labelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // Creates rounded indicator
                    // color: Colors.grey.withOpacity(0.2), // Indicator color
                    color: ColoursUtils.background, // Indicator color
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: AppLocalizations.of(context).translate('login')),
                    Tab(text: AppLocalizations.of(context).translate('signup')),
                  ],
                ),
              ),
              // Tab bar content (Login and Sign Up)
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    1.8, // Set height for the tab view content
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // Login Tab
                    LoginBottomSheetContent(),
                    // Sign Up Tab
                    SignUpBottomSheetContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
