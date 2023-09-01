import 'package:bn_sl/models/login_request.dart';
import 'package:bn_sl/services/login/user_manager.dart';
import 'package:bn_sl/user_details.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:bn_sl/widgets/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

String error = "";
bool _obscureText = true;
String username = "";
String password = "";
Color loginBtn = btnColor;

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffe8e8e8),
        body: SafeArea(
          child: Center(
            child: Container(
              width: wid > widthResponsiveness ? wid / 2 : wid,
              height: wid > widthResponsiveness ? hei / 1.7 : hei,
              decoration: BoxDecoration(
                borderRadius: wid > widthResponsiveness
                    ? BorderRadius.all(
                        Radius.circular(35),
                      )
                    : null,
                color: bColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(7, 7),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login to",
                    style: TextStyle(fontSize: 20, color: textWhite),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Batam Nuts",
                    style: TextStyle(fontSize: 25, color: textWhite),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: wid,
                    height: 175,
                    child: Column(
                      children: [
                        loginFields(
                            wid, 80, "Username", Icons.person_outline_rounded,
                            (val) {
                          setState(() {
                            username = val;
                          });
                        }, () {
                          //
                        }, false, _emailController),
                        SizedBox(
                          height: 15,
                        ),
                        loginFields(wid, 80, "Password", Icons.password_rounded,
                            (val) {
                          setState(() {
                            password = val;
                          });
                        }, () {
                          setState(() {
                            _obscureText == true ? _obscureText = false : _obscureText = true;
                          });
                        }, _obscureText, _passwordController),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$error",
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  MouseRegion(
                    onHover: (a) {
                      setState(() {
                        loginBtn = btnColorHover;
                      });
                    },
                    onExit: (a) {
                      setState(() {
                        loginBtn = btnColor;
                      });
                    },
                    child: InkWell(
                      onTap: () async {
                        if (_emailController.text == "" || _passwordController.text == "") {
                          error = "Fill in username and password";
                        } else {
                          var requstd = new LoginRequest(_emailController.text, _passwordController.text);
                          UserManager uM = UserManager();
                          var res = await uM.login(requstd);
                          if (res != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                              return UserDetails();
                            }));
                          } else {
                            setState(() {
                              error = "Username or password invalid";
                            });
                          }
                        }
                      },
                      child: Container(
                        width: wid * 0.9,
                        height: 60,
                        decoration: BoxDecoration(
                          color: loginBtn,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
