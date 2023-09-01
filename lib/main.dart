import 'package:bn_sl/customers.dart';
import 'package:bn_sl/login.dart';
import 'package:bn_sl/maps.dart';
import 'package:bn_sl/new_oreder.dart';
import 'package:bn_sl/providers/get_token.dart';
import 'package:bn_sl/providers/customer_controller.dart';
import 'package:bn_sl/providers/product_controller.dart';
import 'package:bn_sl/return_list.dart';
import 'package:bn_sl/services/login/auth.dart';
import 'package:bn_sl/summary_invoice.dart';
import 'package:bn_sl/user_details.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'new_return.dart';

void main(){
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context)=> GetToken(),
          ),
          ChangeNotifierProvider(
            create: (context)=> CustomerController(),
          ),
          ChangeNotifierProvider(
            create: (context)=> ProductController(),
          )
        ],
        child: MyApp(),
      ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
String? token;
class _MyAppState extends State<MyApp> {

  Future<Widget> getToken() async {
    String? rToken= await Auth().ReadToken();
    return Future.value(rToken==null?Login():UserDetails());
  }
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = wid <= widthResponsiveness
        ? MediaQuery.of(context).size.height - 60
        : MediaQuery.of(context).size.height;

    bool isBigScreen = wid <= widthResponsiveness ? false : true;
    SystemChrome.setPreferredOrientations([
      isBigScreen?DeviceOrientation.landscapeLeft:DeviceOrientation.portraitUp,
      isBigScreen?DeviceOrientation.landscapeRight:DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EasySplashScreen(
        logo: Image.asset(
            'images/twan-logo.png',
        ),
        backgroundColor: Colors.grey.shade400,
        showLoader: false,
        loadingText: Text("Loading..."),
        futureNavigator: getToken(),
        durationInSeconds: 5,
      ),
    );
  }
}
