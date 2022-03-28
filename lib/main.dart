import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/provider/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final shared = await SharedPreferences.getInstance();
  shared.clear();
  if (shared.getString('language') == null) {
    shared.setString('language', 'en');
  }
  runApp(ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        if (shared.getString('language') == 'en') {
          provider.changeLocale(Locale('en'));
        } else {
          provider.changeLocale(Locale('ar'));
        }
        return MaterialApp(
          title: 'Flutter Demo',
          locale: provider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MyHomePage(),
        );
      }));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Localization')),
      body: Consumer<LocaleProvider>(builder: (context, provider, _) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                    items: L10n.all.map((locale) {
                      return DropdownMenuItem(
                        child: Text(locale.languageCode),
                        value: locale,
                      );
                    }).toList(),
                    onChanged: (value) async {
                      print(value.toString());
                      provider.setLocale(value);
                      final shared = await SharedPreferences.getInstance();
                      if (value.toString() == 'en') {
                        shared.setString('language', 'en');
                      } else if (value.toString() == 'ar') {
                        shared.setString('language', 'ar');
                      }
                    }),
              ),
              Text(AppLocalizations.of(context)!.language),
              Text(AppLocalizations.of(context)!.hello('Mahbub')),
            ],
          ),
        );
      }),
    );
  }
}
