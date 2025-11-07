import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('de'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('de')];

  static final Map<String, Map<String, String>> _localizedValues = {
    'de': {
      'appTitle': 'Customizza',
      'navHome': 'Home',
      'navDesigner': 'Design',
      'navSpecials': 'Specials',
      'navCart': 'Bag',
      'searchHint': 'Nach Pizza suchen...',
      'popularPizzas': 'Beliebte Pizzen',
      'nearbyTitle': 'Pizzeria um die Ecke',
      'nearbyCta': 'Jetzt bestellen',
      'designerTitle': 'Deine Pizza',
      'sizeSmall': 'S',
      'sizeMedium': 'M',
      'sizeLarge': 'L',
      'apply': 'Übernehmen',
      'quantity': 'Menge',
      'cartTitle': 'Warenkorb',
      'checkout': 'Zur Kasse',
      'delivery': 'Lieferung',
      'pickup': 'Abholung',
      'preorder': 'Vorbestellen',
      'now': 'Sofort',
      'paymentDemo': 'Jetzt bezahlen (Demo)',
      'admin': 'Admin',
      'auth': 'Anmeldung',
    },
  };

  String t(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(Locale(locale.languageCode));

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
