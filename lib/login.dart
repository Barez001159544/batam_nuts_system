import 'package:bn_sl/models/login_request.dart';
import 'package:bn_sl/services/login/user_manager.dart';
import 'package:bn_sl/user_details.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:bn_sl/widgets/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/response_login.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}
String error="";
bool _obscureText = true;
String username = "";
String password = "";
Color loginBtn = btnColor;

class _LoginState extends State<Login> {
  bool _isChecked = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // _loadUserEmailPassword();
  }

  // final Future<String> _calculation = Future<String>.delayed(
  //   const Duration(seconds: 2),
  //   () => 'Data Loaded',
  // );
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
              width: wid>widthResponsiveness?wid/2:wid,
              height: wid>widthResponsiveness?hei/1.7:hei,
              decoration: BoxDecoration(
                borderRadius: wid>widthResponsiveness?BorderRadius.all(
                  Radius.circular(35),
                ):null,
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
                            wid,80, "Username", Icons.person_outline_rounded,
                            (val) {
                          setState(() {
                            username = val;
                          });
                        }, () {
                          setState(() {
                            // _obscureText==true?_obscureText=false:_obscureText=true;
                          });
                        }, false, _emailController),
                        // loginFields(wid, "Username", Icons.person_outline_rounded),
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
                            _obscureText == true
                                ? _obscureText = false
                                : _obscureText = true;
                          });
                        }, _obscureText, _passwordController),
                        // loginFields(wid, "Password", Icons.lock_outline_rounded),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Text("$error", style: TextStyle(color: Colors.red, fontSize: 10),),),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MouseRegion(
                    onHover: (a) {
                      setState(() {
                        loginBtn = btnColorHover;
                      });
                      print("Hovered!");
                    },
                    onExit: (a) {
                      setState(() {
                        loginBtn = btnColor;
                      });
                      print("Hover Out");
                    },
                    child: InkWell(
                      onTap: () async {
                        if(_emailController.text=="" || _passwordController.text==""){
                          error="Fill in username and password";
                        }else{
                          var requstd = new LoginRequest(
                              _emailController.text, _passwordController.text);
                          // // requstd.username=_emailController.text;
                          // // requstd.password=_passwordController.text;
                          // //
                          // // print("${requstd.username}  and m ${requstd.password}");
                          // DataServices services = DataServices(requstd.username, requstd.password);
                          // String token;
                          // token = await services.login();
                          // // services.getLogin(_emailController.text, _passwordController.text);
                          // // print(token);

                          print(username);
                          print(password);
                          UserManager uM = UserManager();
                          var res= await uM.login(requstd);
                          print("$res))))))))))");
                          if(res != null){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx){
                              return UserDetails();
                            }));
                          }else{
                            setState(() {
                              error="Username or password invalid";
                            });
                            //error display
                          }
                        }
                        // Future<String> token = await returnedToken();
    //                     final Future<String> _calculationn =
    //                         Future<String>.delayed(
    //                       const Duration(seconds: 2),
    //                       () async{
    //                         final storage = new FlutterSecureStorage();
    //                         String? token=await storage.read(key: "accessToken");
    //                         return token!;
    //                         // return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImM4M2Q3NDFjLTkyMTEtNDAwZi1hNmQyLTQ4NjU4MzZmNTFmZSIsIndhcmVob3VzZWlkIjoiMSIsImlzcmVwcmVzZW50YXRpdmUiOiJGYWxzZSIsImZ1bGxuYW1lIjoiaGltZGFkIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZW1haWxhZGRyZXNzIjoiaGltZGFkQHR3YW4uY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6ImhpbWRhZCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJTdG9jayIsIkRhc2hib2FyZCIsIk1hbmFnZXIiLCJSZXBvcnQiXSwibmJmIjoxNjg5MDA1ODQyLCJleHAiOjE2OTAyMTU0NDIsImlzcyI6Imh0dHA6Ly9iYXJlemF6YWQtMDAxLXNpdGUxLmN0ZW1wdXJsLmNvbS8iLCJhdWQiOiJodHRwOi8vYmFyZXphemFkLTAwMS1zaXRlMS5jdGVtcHVybC5jb20ifQ.tk3SXr0CvTlaRbHEP9Ah8KTnxftzM3v7Fyp8h9FEnZ8";
    //                       },
    //                     );
    //                     Navigator.push(context,
    //                         MaterialPageRoute(builder: (ctx) {
    //                       // returnedToken();
    //                       // return UserDetails(token);
    //                        return FutureBuilder(
    //                           future: _calculationn,
    //                           builder: (BuildContext context,
    //                               AsyncSnapshot<String> snapshot) {
    //                             if (snapshot.hasData) {
    //                               return UserDetails(snapshot.data.toString());
    //                               // print("***************************l");
    //                               // print(snapshot);
    //                               // UserDetails(snapshot.data.toString());
    //                               // print("***************************l");
    //                               // UserDetails(snapshot.data.toString());
    //                             } else if (snapshot.hasError) {
    //                               Column(
    //                                   children : <Widget>[
    //                                     const Icon(
    //                                       Icons.error_outline,
    //                                       color: Colors.red,
    //                                       size: 60,
    //                                     ),
    //                                     Padding(
    //                                       padding: const EdgeInsets.only(top: 16),
    //                                       child: Text('Error: ${snapshot.error}'),
    //                                     ),
    //                                   ],
    //                               );
    //                             }else{
    //                               Column(
    //                                   children: const <Widget>[
    //                                     SizedBox(
    //                                       width: 60,
    //                                       height: 60,
    //                                       child: CircularProgressIndicator(),
    //                                     ),
    //                                     Padding(
    //                                       padding: EdgeInsets.only(top: 16),
    //                                       child: Text('Awaiting result...'),
    //                                     ),
    //                                   ],
    //                               );
    //                             }
    //                             print("***************************l");
    //                             print(snapshot.data);
    //                             print("***************************l");
    //                             return UserDetails(snapshot.data.toString());
    //                           });
    // }));
                      },
                      // onHover: (val){
                      //   setState(() {
                      //     val == true ? loginBtn = btnColorHover: loginBtn = btnColor;
                      //   });
                      //   print("HOVERED");
                      // },
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
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text("Don't have an account? ", style: TextStyle(color: Colors.black54),),
                  //     GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           print("Sign Up");
                  //         });
                  //       },
                  //       child: Container(
                  //         child: Text(
                  //           "Sign Up",
                  //           style: TextStyle(
                  //               color: btnColor, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _handleRemeberme(bool value) {
  //   _isChecked = value;
  //   SharedPreferences.getInstance().then(
  //     (prefs) {
  //       prefs.setBool("remember_me", value);
  //       prefs.setString('email', _emailController.text);
  //       prefs.setString('password', _passwordController.text);
  //     },
  //   );
  //   setState(() {
  //     _isChecked = value;
  //   });
  // }

  // void _handleRemebermee(bool value) {
  //   print("Handle Rember Me");
  //   _isChecked = value;
  //   SharedPreferences.getInstance().then(
  //     (prefs) {
  //       prefs.setBool("remember_me", value);
  //       prefs.setString('email', _emailController.text);
  //       prefs.setString('password', _passwordController.text);
  //     },
  //   );
  //   setState(() {
  //     _isChecked = value;
  //   });
  // }

  Future<String?> returnedToken() async {
    String? token = "";
    // try {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: "accessToken");
    // } catch (e) {
    //   print(e);
    // }
    print("========================+");
    print(token);
    print("========================+");
    return token;
  }

  // void _loadUserEmailPassword() async {
  //   print("Load Email");
  //   try {
  //     SharedPreferences _prefs = await SharedPreferences.getInstance();
  //     var _email = _prefs.getString("email") ?? "";
  //     var _password = _prefs.getString("password") ?? "";
  //     var _remeberMe = _prefs.getBool("remember_me") ?? false;
  //
  //     print(_remeberMe);
  //     print(_email);
  //     print(_password);
  //     if (_remeberMe) {
  //       setState(() {
  //         _isChecked = true;
  //       });
  //       _emailController.text = _email ?? "";
  //       _passwordController.text = _password ?? "";
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

}
