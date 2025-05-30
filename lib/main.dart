import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/utils/utility.dart';
import 'package:provider/provider.dart';

import 'language/app_localizations.dart';
import 'language/locale_constant.dart';
import 'notifire_class.dart';
import 'screens/auth_module/welcome_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLinks().getLatestLink();
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider<LocalizationNotifier>(
        create: (_) => LocalizationNotifier(Locale('en')),
      ),
    ],
    child: const MyApp(),
  ));
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
      print("locale>>>>>>>>>>>>>$_locale");
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
    Storage().getLanguage().then((value) {
      final langNotifier = Provider.of<LocalizationNotifier>(context, listen: false);
      langNotifier.setAppLocal(Locale(value.isNotEmpty ? value : "en"));
    },);
    var langNotifier = Provider.of<LocalizationNotifier>(context);
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
        locale: langNotifier.appLocal, // Default to English
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // For Cupertino widgets
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocaleLanguage in supportedLocales) {
            if (supportedLocaleLanguage.languageCode ==
                locale?.languageCode /*&& supportedLocaleLanguage.countryCode == locale?.countryCode*/) {
              return supportedLocaleLanguage;
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
