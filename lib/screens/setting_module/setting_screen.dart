import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/screens/setting_module/terms_policy_page.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../language/app_localizations.dart';
import '../../main.dart';
import '../../utils/utility.dart';
import '../auth_module/welcome_screen.dart';
import '../subscription_module/subscription_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SharedPreferences prefs;
  @override
  void initState() {
    sharedPreInit();
    super.initState();
  }

  void sharedPreInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoursUtils.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(context), // Default action: Go back
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 2,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('Settings'),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const SizedBox(height: 14),
              // Delete Account (Separate Widget)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Colors.blue.shade300,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('language'),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    bottomSheetDropdown(context);
                    // Handle delete account action
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Delete Account (Separate Widget)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.subscriptions,
                    color: Colors.blue.shade300,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('subscription'),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen(),));
                 },
                ),
              ),
              const SizedBox(height: 14),
              // Delete Account (Separate Widget)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.privacy_tip,
                    color: Colors.blue.shade300,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('privacyPolicy'),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TermsPolicyPage(title: 'Privacy Policy',),));
                    // Handle delete account action
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Delete Account (Separate Widget)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.article,
                    color: Colors.blue.shade300,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('termsAndConditions'),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TermsPolicyPage(title: 'Terms and Conditions',),));
                    // Handle delete account action
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Delete Account (Separate Widget)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue.shade300,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('linkedAccount'),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // Handle delete account action
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Delete Account (Separate Widget)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('deleteAccount'),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    showDeleteDialog(context);
                    // Handle delete account action
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Delete Account (Separate Widget)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('logoutAccount'),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    showlogoutDialog(context);
                  },
                ),
              ),
              // Team Name Input
            ],
          ),
        ),
      ),
    );
  }


  String selectedLanguage = "";
   bottomSheetDropdown(BuildContext context) {
    return    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
        AppLocalizations.of(context).translate('selectAnyLanguage'),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                'English',
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                setState(() {
                  // _selectedValue = 'English';
                  // _selectedLanguageId = '1';
                  selectedLanguage = 'English';
                  MyApp.setLocale(context, Locale('en'));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'French',
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                setState(() {
                  // _selectedValue = 'French';
                  // _selectedLanguageId = '2';
                  selectedLanguage = 'French';
                  MyApp.setLocale(context, Locale('fr'));
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showlogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text( AppLocalizations.of(context).translate('logout1'),),
          content: Text( AppLocalizations.of(context).translate('areYouWLogout'),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here

                clearSharedPreferences(context);
                // Close the dialog
              },
              child: Text( AppLocalizations.of(context).translate('logout'),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text( AppLocalizations.of(context).translate('cancel'),),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text( AppLocalizations.of(context).translate('deleteAccount'),),
          content: Text( AppLocalizations.of(context).translate('areYouWDeleteAccount'),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop();
              },
              child: Text( AppLocalizations.of(context).translate('delete'),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text( AppLocalizations.of(context).translate('cancel'),),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearSharedPreferences(context) async {
    Utility.showLoader(context);


    bool success = await prefs.clear(); // Clears all key-value pairs
    if (success) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => WelcomePage()),
            (route) => false,
          );
           Utility.hideLoader(context);
        },
      );

      debugPrint("SharedPreferences cleared successfully.");
    } else {
      debugPrint("Failed to clear SharedPreferences.");
    }
  }
}
