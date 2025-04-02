import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/utils/utility.dart';

import 'language/app_localizations.dart';
import 'language/locale_constant.dart';
import 'screens/auth_module/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLinks().getLatestLink();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', '');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      duration: Durations.medium4,
      reverseDuration: Durations.medium4,
      disableBackButton: true,
      closeOnBackButton: true,
      overlayHeight: MediaQuery.sizeOf(context).height / 2,
      useBackButtonInterceptor: true,
      overlayWidgetBuilder: (progress) {
        return Center(
          child:  CircularProgressIndicator(
               color: Colors.blue,
          ),
        );
      },
      useDefaultLoading: true,
      
      overlayColor: Colors.transparent,
   
      child: MaterialApp(
        title: 'Digital Card',
          navigatorKey:navigatorKey,
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('fr', ''), // French
        ],
        locale: _locale, // Default to English
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // For Cupertino widgets
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: false,
        ),
        home: WelcomePage(),
        //  home:  BottomNavBarExample(),
      ),
    );
  }
}
