import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:restaurant_rider/localization/app_localization.dart';
import 'package:restaurant_rider/provider/auth_provider.dart';
import 'package:restaurant_rider/provider/localization_provider.dart';
import 'package:restaurant_rider/provider/language_provider.dart';
import 'package:restaurant_rider/provider/location_provider.dart';
import 'package:restaurant_rider/provider/order_provider.dart';
import 'package:restaurant_rider/provider/profile_provider.dart';
import 'package:restaurant_rider/provider/splash_provider.dart';
import 'package:restaurant_rider/provider/theme_provider.dart';
import 'package:restaurant_rider/provider/tracker_provider.dart';
import 'package:restaurant_rider/theme/dark_theme.dart';
import 'package:restaurant_rider/theme/light_theme.dart';
import 'package:restaurant_rider/utill/app_constants.dart';
import 'package:restaurant_rider/view/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TrackerProvider>()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getUserLocation();
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return MaterialApp(
      title: 'eFood Delivery Boy UI Kit',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _locals,
      home: SplashScreen(),
    );
  }
}
