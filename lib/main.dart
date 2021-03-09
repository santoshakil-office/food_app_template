import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'models/cart.dart';
import 'models/order.dart';
import 'models/profile.dart';
import 'routes/router.gr.dart';
import 'values/values.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConst.APP_NAME,
      theme: AppTheme.themeData,
      onGenerateRoute: AppRouter(),
      builder: ExtendedNavigator.builder<AppRouter>(
        router: AppRouter(),
        initialRoute: Routes.splashScreen,
        builder: (context, extendedNav) => MultiProvider(
          providers: [
            ChangeNotifierProvider<Profile>(
              create: (_) => Profile(
                name: 'Marvis Ighedosa',
                email: 'dosamarvis@gmail.com',
                address:
                    'No 15 uti street off ovie palace road effurun delta state',
                mobile: '+234 9011039271',
              ),
            ),
            ChangeNotifierProvider<Cart>(
              create: (_) => Cart(),
            ),
            ChangeNotifierProvider<Orders>(
              create: (_) => Orders(),
            ),
          ],
          child: extendedNav,
        ),
      ),
    );
  }
}
