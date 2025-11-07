import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/l10n.dart';
import 'core/theme.dart';
import 'data/mock_repos.dart';
import 'state/app_state.dart';
import 'ui/pages/admin_page.dart';
import 'ui/pages/auth_page.dart';
import 'ui/pages/cart_page.dart';
import 'ui/pages/checkout_page.dart';
import 'ui/pages/designer_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/shell_page.dart';
import 'ui/pages/specials_page.dart';

void main() {
  runApp(const CustomizzaApp());
}

class CustomizzaApp extends StatelessWidget {
  const CustomizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(
            authRepository: InMemoryAuthRepository(),
            menuRepository: InMemoryMenuRepository(),
            orderRepository: InMemoryOrderRepository(),
            offersRepository: InMemoryOffersRepository(),
            settingsRepository: InMemorySettingsRepository(),
          )..load(),
        ),
      ],
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'Customizza',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: ShellPage.routeName,
            routes: {
              ShellPage.routeName: (_) => const ShellPage(),
              HomePage.routeName: (_) => const HomePage(),
              DesignerPage.routeName: (_) => const DesignerPage(),
              SpecialsPage.routeName: (_) => const SpecialsPage(),
              CartPage.routeName: (_) => const CartPage(),
              CheckoutPage.routeName: (_) => const CheckoutPage(),
              AdminPage.routeName: (_) => const AdminPage(),
              AuthPage.routeName: (_) => const AuthPage(),
            },
          );
        },
      ),
    );
  }
}
