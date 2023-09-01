import 'package:bn_sl/models/customer_response.dart';
import 'package:bn_sl/models/order_response.dart';
import 'package:bn_sl/models/return_details_view.dart';
import 'package:bn_sl/models/return_response.dart';
import 'package:bn_sl/return_heade_response.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../login.dart';
import '../models/items_pagnation_response.dart';
import '../models/order_details_response.dart';
import '../models/order_details_view.dart';
import '../models/product_response.dart';

Color bColor = Color(0xffffffff);
Color btnColor = Color(0xff86A272);
Color btnColorHover = Color(0xff08814b);
Color elements = Colors.grey;
Color textWhite = Color(0xb886a272);
double widthResponsiveness = 600;
double titleOne = 40;
double subTitleOne = 15;

Widget loginFields(
    double wid,
    double height,
    String hintText,
    IconData icon,
    void onChange(val),
    void onHideShow(),
    bool _obscureText,
    TextEditingController controller) {
  // bool _obscureText=true;
  return Container(
    width: wid * 0.9,
    height: height,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Color(0xfff8f8f8),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      // border: Border.all(color: elements, style: BorderStyle.solid, width: 3),
    ),
    child: Row(
      children: [
        Icon(icon, color: elements),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: TextFormField(
            obscureText: hintText == "Password" ? _obscureText : false,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "$hintText",
              hintStyle: TextStyle(color: elements),
            ),
            onChanged: (val) {
              onChange(val);
            },
            controller: controller,
          ),
        ),
        hintText == "Password"
            ? GestureDetector(
                onTap: () {
                  onHideShow();
                },
                child: Container(
                  height: 80,
                  width: 30,
                  child: Icon(
                    _obscureText == false
                        ? Icons.lock_outline_rounded
                        : Icons.lock_open_rounded,
                    color: elements,
                  ),
                ),
              )
            : Container(),
      ],
    ),
  );
}
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
Widget insideDrawer(double wid, double hei, List icons,
    Map<String, dynamic> decodedToken, List roles, void onPageChosen(index), int pi, onDrawerItemChange(index), context, void onProfileClick()) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    width: wid <= 600 ? wid * 0.9 : wid * 0.4,
    height: hei,
    color: bColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(100),
        //         ),
        //         border: Border.all(
        //           color: Colors.black54,
        //           width: 5,
        //           style: BorderStyle.solid,
        //         ),
        //       ),
        //       child: Icon(
        //         Icons.person_outline_rounded,
        //         size: 50,
        //         color: Colors.black54,
        //       ),
        //     ),
        //     SizedBox(
        //       width: 20,
        //     ),
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           "${decodedToken["fullname"].toString().toCapitalized()}",
        //           style: TextStyle(
        //               fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
        //         ),
        //         Text(
        //           "Representative",
        //           style: TextStyle(
        //               fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 50,
        // ),
        Container(
          height: hei - 200,
          child: ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onDrawerItemChange(index);
                    onPageChosen(index);
                    Navigator.pop(context);
                    print("${roles[index]}");
                  },
                  child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: wid * 0.4,
                      height: wid>=600?60:60,
                      decoration: BoxDecoration(
                        color: index == pi ? btnColor : Color(0xfff8f8f8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            icons[index],
                            size: 20,
                            color: index == pi ? Colors.white : Colors.black54,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                              child: Text(
                            "${roles[index]}",
                            style: TextStyle(
                                color:
                                    index == pi ? Colors.white : Colors.black54,
                                fontSize: 15,
                                height: 1.5),
                          )),
                        ],
                      )),
                );
              }),
        ),
        SwipeButton(
          borderRadius: BorderRadius.circular(15),
          activeTrackColor: Colors.grey,
          height: 80,
          activeThumbColor: Colors.transparent,
          thumbPadding: EdgeInsets.all(3),
          thumb: GestureDetector(
            onTap: (){
              print("object");
            },
            child: GestureDetector(
              onTap: (){
                onProfileClick();
              },
              child: Container(
                padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white, //Color(0xffF04372),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                child: SvgPicture.asset(
                    'images/007-boy-2.svg',
                    semanticsLabel: 'Acme Logo'
                ),
                        ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(
                width: 80,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FaIcon(FontAwesomeIcons.chevronRight, color: Colors.white, size: 15,),
                    FaIcon(FontAwesomeIcons.chevronRight, color: Colors.white, size: 15,),
                    FaIcon(FontAwesomeIcons.chevronRight, color: Colors.white, size: 15,),
                  ],
                ),
              ).animate( onComplete: (controller)=> controller.loop(reverse: true)).tint(color: Colors.grey, duration: 2.seconds, curve: Curves.easeInOut),
              Tooltip(
                message: "Swipe to Log Out",
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                    child: FaIcon(FontAwesomeIcons.rightFromBracket, color: Colors.white,),
                ),
              ),
            ],
          ),
          onSwipe: () async{
            print("Logged Out");
            final storage = new FlutterSecureStorage();
            await storage.delete(key: "accessToken");
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Login()), (route) => false);
          },
        ),
        // Flexible(
        //   child: Container(
        //     margin: EdgeInsets.only(bottom: 10),
        //     height: 80,
        //     decoration: BoxDecoration(
        //       color: Colors.blue,
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(15),
        //       ),
        //     ),
        //     child: Row(
        //       children: [
        //         Container(
        //           margin: EdgeInsets.all(10),
        //           height: 60,
        //           width: 60,
        //           decoration: BoxDecoration(
        //             color: Colors.red,
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(15),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

Widget tabletHalfSidebar(double hei, List icons, int pi, bool isBigScreen) {
  return Container(
    padding: EdgeInsets.all(10),
    width: 80,
    height: hei,
    color: bColor,
    child: ListView.builder(
        itemCount: icons.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            width: isBigScreen?60:80,
            height: isBigScreen?60:80,
            decoration: BoxDecoration(
              color: index == pi ? btnColor : Color(0xfff8f8f8),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(child: FaIcon(icons[index], color: index == pi ? Colors.white : Colors.black54, size: 20,)),
            // Icon(
            //   icons[index],
            //   color: index == pi ? Colors.white : Colors.black54,
            // ),
          );
        }),
  );
}

Widget numberTextField(double wid, double hei, TextEditingController controller,
    void onDecrement(), void onIncrement()) {
  return Container(
    width: wid,
    height: hei,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    decoration: BoxDecoration(
      color: Color(0xfff8f8f8),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 20),
            onChanged: (value) {
              // setState(() {
              // givenMoney2 = value;
              // });
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            onDecrement();
          },
          child: Icon(
            Icons.minimize,
            size: 20,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            onIncrement();
          },
          child: Icon(
            Icons.add,
            size: 20,
          ),
        ),
      ],
    ),
  );
}

Widget cTextfield(double wid, double height, void onChange(val),
    TextEditingController controller, String hint, TextDirection tD) {
  // bool _obscureText=true;
  return Container(
    width: wid,
    height: height,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Color(0xfff8f8f8),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: Center(
      child: TextFormField(
        textDirection: tD,
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: "$hint",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          isCollapsed: true,
          border: InputBorder.none,
        ),
        onChanged: (val) {
          onChange(val);
        },
        controller: controller,
      ),
    ),
  );
}

Widget customDropDownMenu(double wid, double height,
    List<CustomerResponse>? items, String? value, void onChange(val), context) {
  return Container(
    width: wid,
    height: height,
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Color(0xfff8f8f8),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        dropdownColor: Color(0xfff8f8f8),
        isExpanded: false,
        disabledHint: Text("Select a Customer"),
        hint: Text("Select a Customer"),
        value: value != null ? value : null,
        style: TextStyle(color: Colors.black),
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          size: 30,
          color: Colors.black54,
        ),
        items: List<CustomerResponse>.from(items as Iterable)
            .map((CustomerResponse itemss) {
          return DropdownMenuItem(
            value: itemss.name,
            child: Center(
                child: Text(
              itemss.name,
              textAlign: TextAlign.center,
            )),
          );
        }).toList(),
        onChanged: (val) {
          onChange(val);
        },
      ),
    ),
  );
}

Widget searchTextField(double wid, double height, void onSubmited(value),
    void onChange(value), TextEditingController controller) {
  return Container(
    width: wid,
    height: height,
    padding: EdgeInsets.only(left: 5, bottom: 5),
    decoration: BoxDecoration(
      color: Color(0xfff8f8f8),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: Column(
      children: [
        Flexible(
          child: TextField(
            textDirection: TextDirection.rtl,
            onSubmitted: (subject) {
              onSubmited(subject);
            },
            onChanged: (value) {
              onChange(value);
            },
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              icon: Icon(
                Icons.search_rounded,
                color: Colors.grey,
              ),
            ),
            controller: controller,
          ),
        ),
      ],
    ),
  );
}

Widget customAlertDialog(Icon alertIcon, String title, String message,
    String btnMessage, ctx, void onGotIt()) {
  return AlertDialog(
    actionsPadding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    icon: alertIcon,
    // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
    title: Text(
      "$title",
      textAlign: TextAlign.center,
    ),
    content: Row(
      children: [
        Flexible(
          child: Text(
            "$message",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
      ],
    ),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowButtonSpacing: 8.0,
    actions: [
      GestureDetector(
        onTap: () {
          onGotIt();
          // Navigator.of(ctx).pop();
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          child: Center(
              child: Text(
            '$btnMessage',
            style: TextStyle(color: bColor, fontSize: 15),
          )),
        ),
      ),
      // TextButton(
      //   onPressed: () => Navigator.of(ctx).pop(),
      //   child: Text('Got It!', style: TextStyle(color: Colors.black),),
      // ),
    ],
  );
}

Widget cofirmationCustomAlertDialog(
    FaIcon alertIcon,
    String title,
    String message,
    String btnMessage,
    String btnMessage2,
    ctx,
    void onGotIt(),
    void onDecline()) {
  return AlertDialog(
    actionsPadding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    icon: Center(child: alertIcon),
    // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
    title: Text(
      "$title",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    content: Row(
      children: [
        Flexible(
          child: Text(
            "$message",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowButtonSpacing: 8.0,
    actions: [
      Column(
        children: [
          GestureDetector(
            onTap: () {
              onGotIt();
              // Navigator.of(ctx).pop();
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                  child: Text(
                '$btnMessage2',
                style: TextStyle(
                    color: bColor, fontSize: 15, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              onDecline();
              // Navigator.of(ctx).pop();
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Colors.transparent,
              child: Center(
                  child: Text(
                '$btnMessage',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
      // TextButton(
      //   onPressed: () => Navigator.of(ctx).pop(),
      //   child: Text('Got It!', style: TextStyle(color: Colors.black),),
      // ),
    ],
  );
}

Widget orderInfoAlertDialog(double wid, double hei, bool isBigScreen,
    String btnMessage, ctx, void onGotIt(), OrderResponse orderResponse, List<OrderDetailsResponse>? orderDetailsResponse, ScrollController scrollController1, ScrollController scrollController2) {
  return AlertDialog(
    actionsPadding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    // icon: alertIcon,
    // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
    // title: Text(
    //   "$title",
    //   textAlign: TextAlign.center,
    // ),
    content: Container(
      width: wid,
      height: hei,
      child: Column(
        children: [
              Text("#${orderResponse.orderNumber}", style: TextStyle(fontSize: subTitleOne, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 30,
            child: Flex(
              direction: isBigScreen?Axis.horizontal:Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Issue Date:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.createdAt.split("T")[0]}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Required Date:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.date.split("T")[0]}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 30,
            child: Flex(
              direction: isBigScreen?Axis.horizontal:Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Customer:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.customerText}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Representative:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.representative}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 30,
            child: Flex(
              direction: isBigScreen?Axis.horizontal:Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.status==1?"Approved":"Pending"}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Note:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.note==""?"Empty":orderResponse.note}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: btnColor.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black54),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (hei-10)/4,
                      child: Text("Description", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                  Container(
                      width: (hei-10)/4,
                      child: Text("Price", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                  Container(
                      width: (hei-10)/4,
                      child: Text("Quantity", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                  Container(
                      width: (hei-10)/4,
                      child: Text("Amount", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orderDetailsResponse?.length,
                itemBuilder: (ctx, index){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  )
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (hei-10)/4,
                          child: Text("${orderDetailsResponse?[index].productText}", style: TextStyle(fontSize: 10),)),
                      Container(
                          width: (hei-10)/4,
                          child: Text("${orderDetailsResponse?[index].subtotal}", style: TextStyle(fontSize: 10),)),
                      Container(
                          width: (hei-10)/4,
                          child: Text("${orderDetailsResponse?[index].quantity}", style: TextStyle(fontSize: 10),)),
                      Container(
                          width: (hei-10)/4,
                          child: Text("${orderDetailsResponse?[index].price}", style: TextStyle(fontSize: 10),)),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Qty:", style: TextStyle(color: Colors.black54),),
                      Text("${orderDetailsResponse?.length}"),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Total:", style: TextStyle(color: Colors.black54),),
                      Text("${orderResponse.total}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    // Row(
    //   children: [
    //     Flexible(
    //       child: Column(
    //         children: [
    //           Row(
    //             children: [
    //               Container(
    //                 width: isBigScreen?50:25,
    //                 height: isBigScreen?50:25,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.shade100,
    //                   borderRadius: BorderRadius.all(
    //                     Radius.circular(10),
    //                   ),
    //                 ),
    //               ),
    //               Column(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Text("Order ID"),
    //                       Text("Order ID"),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // ),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowButtonSpacing: 8.0,
    actions: [
      GestureDetector(
        onTap: () {
          onGotIt();
          // Navigator.of(ctx).pop();
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xff606060),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          child: Center(
              child: Text(
            '$btnMessage',
            style: TextStyle(color: bColor, fontSize: 15),
          )),
        ),
      ),
      // TextButton(
      //   onPressed: () => Navigator.of(ctx).pop(),
      //   child: Text('Got It!', style: TextStyle(color: Colors.black),),
      // ),
    ],
  );
}

Widget generateNumberWithBtn(
  double wid,
  double hei,
  TextEditingController controller,
  void onGenerate(),
) {
  return Container(
    width: wid,
    height: hei,
    padding: EdgeInsets.only(
      left: 10,
    ),
    decoration: BoxDecoration(
      color: Color(0xfff8f8f8),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            textAlignVertical: TextAlignVertical.top,
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 15),
            onChanged: (value) {},
          ),
        ),
        GestureDetector(
          onTap: () {
            onGenerate();
          },
          child: Container(
            color: Colors.transparent,
            width: hei,
            height: hei,
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.pix,
                size: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget productScreen(
    double wid,
    void onSubmit(),
    void onChange(val),
    void onItemTap(index),
    List<ProductResponse> products,
    bool isBigScreen,
    TextEditingController controller) {
  return Container(
    color: isBigScreen == true ? Colors.transparent : Colors.transparent,
    width: wid * 0.3,
    padding: EdgeInsets.all(10),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: isBigScreen ? 0 : 5),
      width: wid * 0.3,
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: bColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchTextField(isBigScreen ? wid * 0.2 : wid * 0.8, 40, (val) {
                  onSubmit();
                }, (val) {
                  onChange(val);
                  // setState(() {
                  //   overallItems.clear();
                  //   searchQuery=val;
                  // });
                  // product();
                  // print("value: ${val==''?"g":"N"}----");
                }, controller),
                Container(
                  width: isBigScreen ? wid * 0.06 : wid * 0.1,
                  height: 40,
                  child: Center(
                      child: Text(
                    "${products.isNotEmpty?products.length:0}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: isBigScreen ? 20 : 0,
          ),
          Flexible(
            child: GridView.count(
              scrollDirection:
                  isBigScreen == true ? Axis.vertical : Axis.horizontal,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: isBigScreen ? (wid>800?2:1) : 1,
              childAspectRatio: isBigScreen ? 1 : 1.5,
              padding: EdgeInsets.all(10),
              children: List.generate(
                  products.isNotEmpty ? products.length : 10, (index) {
                return products.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          // setState(() {
                          onItemTap(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: bColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(7, 7),
                              ),
                            ],
                          ),
                          // margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: isBigScreen ? wid * 0.05 : wid * 0.25,
                                height: isBigScreen ? wid * 0.05 : wid * 0.25,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${products[index].sku}",
                                    style: TextStyle(
                                        fontSize: isBigScreen ? 10 : 10,
                                        color: btnColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${products[index].name}",
                                    style: TextStyle(
                                        fontSize: isBigScreen ? 12 : 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    "${products[index].quantityAvailable} KG",
                                    style: TextStyle(
                                        fontSize: isBigScreen ? 10 : 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: bColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(7, 7),
                            ),
                          ],
                        ),
                        // margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: isBigScreen ? wid * 0.05 : wid * 0.25,
                              height: isBigScreen ? wid * 0.05 : wid * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  color: Colors.grey.shade100,
                                  width: 70,
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  width: 110,
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  width: 70,
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
              }),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget rowsUsedInSelectedItemsScreen(
    List<OrderDetailsView> orderDetails,
    ScrollController scrollController2,
    void onQtyTextfieldChanged(val, index),
    void onSingleItemDeleted(index),
    int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 100,
        child: Text(
          "${(orderDetails[index]).sku}",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "${(orderDetails[index]).productText}",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "${(orderDetails[index]).available}",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "${(orderDetails[index]).subtotal}",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        padding: EdgeInsets.only(right: 60),
        width: 100,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Center(
            child: TextField(
              // initialValue: "$initialValue",
              controller: TextEditingController(
                  text: "${orderDetails[index].quantity}"),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                onQtyTextfieldChanged(val, index);
                print("$val qty submitted ${orderDetails[index].quantity}");
              },
            ),
          ),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "${orderDetails[index].price} IQD",
          style: TextStyle(fontSize: 12),
        ),
      ),
      GestureDetector(
        onTap: () {
          print("delete $index item");
          onSingleItemDeleted(index);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Icon(
            Icons.delete_rounded,
            size: 20,
          ),
        ),
      ),
    ],
  );
}

Widget selectedItemsScreen(
    List<OrderDetailsView> orderDetails,
    bool isBigScreen,
    ScrollController scrollController2,
    void onQtyTextfieldChanged(val, index),
    void onSingleItemDeleted(index)) {
  return Flexible(
    child: orderDetails.length != 0
        ? ListView.builder(
            itemCount: orderDetails.length,
            itemBuilder: (ctx, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 60,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1,
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid),
                  ),
                ),
                child: isBigScreen == false
                    ? SingleChildScrollView(
                        controller: scrollController2,
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        scrollDirection: Axis.horizontal,
                        child: rowsUsedInSelectedItemsScreen(
                            orderDetails, scrollController2, (val, index) {
                          onQtyTextfieldChanged(val, index);
                        }, (index) {
                          onSingleItemDeleted(index);
                        }, index),
                      )
                    : rowsUsedInSelectedItemsScreen(
                        orderDetails, scrollController2, (val, index) {
                        onQtyTextfieldChanged(val, index);
                      }, (index) {
                        onSingleItemDeleted(index);
                      }, index),
              );
            })
        : Center(
            child: Container(
              width: isBigScreen ? 300 : 200,
              height: isBigScreen ? 300 : 200,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage("images/9650074_7612.jpg"),
              //   ),
              // ),
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.boxOpen,
                size: 150,
                color: Colors.black54,
              )),
            ),
            // Icon(
            //   Icons.cancel_presentation_rounded,
            //   size: 200,
            //   color: Colors.grey,
            // ),
          ),
  );
}

Widget validationErrorMessage(String message) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: 180,
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black54.withOpacity(0.2),
        //     spreadRadius: 1,
        //     blurRadius: 10,
        //     offset: Offset(7, 7),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Color(0xffF04372),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.exclamation,
                size: 15,
                color: Colors.white,
              ))),
          SizedBox(
            width: 10,
          ),
          Text(
            "$message",
            style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
          ),
        ],
      ),
    ),
  );
}

Widget datePicker(BuildContext context, DateTime selectedDate,
    void onPick(DateTime? picked)) {
  return GestureDetector(
    onTap: () {
      _selectDate(context, selectedDate, onPick);
    },
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "${selectedDate.toString().split(" ")[0]}",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          // SizedBox(width: 10,),
          FaIcon(
            FontAwesomeIcons.calendar,
            size: 15,
          ),
        ],
      ),
    ),
  );
}

Widget headOfOrder(
    double wid,
    BuildContext context,
    DateTime selectedDate1,
    DateTime selectedDate2,
    void onPick1(DateTime? picked),
    void onPick2(DateTime? picked),
    bool isBigScreen,
    onChange(value)) {
  return Container(
    height: isBigScreen ? 50 : 80,
    child: Flex(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: isBigScreen ? Axis.horizontal : Axis.vertical,
      children: [
        Container(
          width: isBigScreen ? wid * 0.4 : wid * 0.9,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: datePicker(context, selectedDate1, onPick1),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 10,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              Flexible(
                child: datePicker(context, selectedDate2, onPick2),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        searchTextField(isBigScreen ? wid * 0.25 : wid * 0.9, 35, (value) {},
            (value) {
          onChange(value);
        }, TextEditingController()),
      ],
    ),
  );
}

Future<void> _selectDate(BuildContext context, DateTime selectedDate,
    void onPick(DateTime? picked)) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now());
  if (picked != null && picked != selectedDate) {
    print(picked);
    onPick(picked);
  }
}

Widget rowsUsedInReturnedSelectedItemsScreen(
    List<ReturnDetailsSView> orderDetails,
    ScrollController scrollController2,
    void onQtyTextfieldChanged(val, index),
    void onSingleItemDeleted(index),
    int index, List<String> items, String item, onChange(String val)) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 100,
        child: Text(
          "${(orderDetails[index]).sku}",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "${(orderDetails[index]).productText}",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "KG",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "${(orderDetails[index]).price} IQD",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        padding: EdgeInsets.only(right: 60),
        width: 100,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Center(
            child: TextField(
              // initialValue: "$initialValue",
              controller: TextEditingController(
                  text: "${orderDetails[index].quantity}"),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                onQtyTextfieldChanged(val, index);
                print("$val qty submitted ${orderDetails[index].price}");
              },
            ),
          ),
        ),
      ),
      Container(
        width: 100,
        child: Text(
          "${orderDetails[index].subtotal} IQD",
          style: TextStyle(fontSize: 12),
        ),
      ),
      Container(
        width: 100,
        child: Container(
          width: 100,
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Color(0xfff8f8f8),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              dropdownColor: Color(0xfff8f8f8),
              isExpanded: true,
              hint: Text("Reason"),
              value: orderDetails[index].reason!=""?orderDetails[index].reason:null,
              style: TextStyle(color: Colors.black),
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                size: 30,
                color: Colors.black54,
              ),
              items: List<String>.from(items).map((String itemss) {
                return DropdownMenuItem(
                  value: itemss,
                  child: Center(child: Text(itemss, textAlign: TextAlign.center, style: TextStyle(fontSize: 10),)),
                );
              }).toList(),
              onChanged: (val) {
                onChange(val!);
                // setState(() {
                //   selectedListSize=val!;
                //   pagnationParameter?.pageSize=int.parse(selectedListSize);
                //   pagnationParameter.pageNumber=1;
                //   product();
                // });
                // print(selectedListSize);
              },
            ),
          ),
        ),
        // Text(
        //   "Reason",
        //   style: TextStyle(fontSize: 12),
        // ),
      ),
      GestureDetector(
        onTap: () {
          print("delete $index item");
          onSingleItemDeleted(index);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Icon(
            Icons.delete_rounded,
            size: 20,
          ),
        ),
      ),
    ],
  );
}
Widget returnedSelectedItemsScreen(
    List<ReturnDetailsSView> orderDetails,
    bool isBigScreen,
    ScrollController scrollController2,
    void onQtyTextfieldChanged(val, index),
    void onSingleItemDeleted(index), List<String> items, String item, onChange(val, index)) {
  return Flexible(
    child: orderDetails.length != 0
        ? ListView.builder(
        itemCount: orderDetails.length,
        itemBuilder: (ctx, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1,
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid),
              ),
            ),
            child: isBigScreen == false
                ? SingleChildScrollView(
              controller: scrollController2,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              scrollDirection: Axis.horizontal,
              child: rowsUsedInReturnedSelectedItemsScreen(
                  orderDetails, scrollController2, (val, index) {
                onQtyTextfieldChanged(val, index);
              }, (index) {
                onSingleItemDeleted(index);
              }, index, items, item, (val){
                    onChange(val, index);
              }),
            )
                : rowsUsedInReturnedSelectedItemsScreen(
                orderDetails, scrollController2, (val, index) {
              onQtyTextfieldChanged(val, index);
            }, (index) {
              onSingleItemDeleted(index);
            }, index, items, item, (val){
                  onChange(val, index);
            }),
          );
        })
        : Center(
      child: Container(
        width: isBigScreen ? 300 : 200,
        height: isBigScreen ? 300 : 200,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("images/9650074_7612.jpg"),
        //   ),
        // ),
        child: Center(
            child: FaIcon(
              FontAwesomeIcons.boxOpen,
              size: 150,
              color: Colors.black54,
            )),
      ),
      // Icon(
      //   Icons.cancel_presentation_rounded,
      //   size: 200,
      //   color: Colors.grey,
      // ),
    ),
  );
}


Widget buildBottomDrawer(BuildContext context, Widget body, BottomDrawerController controller) {
  return BottomDrawer(
    header:Container(),
    body: Container(
        width: double.infinity,
        height: 380,
        child:  body
    ),
    headerHeight: 40,
    drawerHeight: MediaQuery.of(context).size.height*0.4,
    color: Colors.transparent,
    controller: controller,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 60,
        spreadRadius: 5,
        offset: const Offset(2, -6), // changes position of shadow
      ),
    ],
  );
}
Widget customerAlertDialog(
    FaIcon alertIcon,
    String title,
    String message,
    String btnMessage,
    String btnMessage2,
    ctx,
    void onGotIt(),
    void onDecline(), TextEditingController name, TextEditingController employee, TextEditingController phoneNumber, TextEditingController address, bool isRed, void onAddLocation()) {
  return AlertDialog(
    actionsPadding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    // icon: Center(child: alertIcon),
    // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        GestureDetector(
          onTap: (){
            onAddLocation();
          },
          child: Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Colors.grey.shade800,
            ),
            child: Center(
              child: Icon(Icons.add_location_alt, color: Colors.white, size: 15, semanticLabel: "Add Customer",),
            ),
          ),
        ),
      ],
    ),
    content: Container(
      width: 300,
      height: 370,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name:"),
                  SizedBox(
                    height: 5,
                  ),
                  cTextfield(300, 50, (val) { }, name, "Enter Name", TextDirection.ltr),
                ],
              ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Employee:"),
              SizedBox(
                height: 5,
              ),
              cTextfield(300, 50, (val) { }, employee, "Enter Employee", TextDirection.ltr),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Phone Number:"),
              SizedBox(
                height: 5,
              ),
              cTextfield(300, 50, (val) { }, phoneNumber, "Enter Phone Number", TextDirection.ltr),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Address:"),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 300,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xfff8f8f8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    maxLines: 2,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "Enter Address",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      // onChange(val);
                    },
                    controller: address,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: 300,
              child: Text("Don't leave any field empty!", style: TextStyle(fontSize: 9, color: isRed==true?Colors.red:Colors.black54),),
          ),
        ],
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowButtonSpacing: 8.0,
    actions: [
      Column(
        children: [
          GestureDetector(
            onTap: () {
              onGotIt();
              // Navigator.of(ctx).pop();
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                  child: Text(
                    '$btnMessage2',
                    style: TextStyle(
                        color: bColor, fontSize: 15, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          GestureDetector(
            onTap: () {
              onDecline();
              // Navigator.of(ctx).pop();
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Colors.transparent,
              child: Center(
                  child: Text(
                    '$btnMessage',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ],
      ),
      // TextButton(
      //   onPressed: () => Navigator.of(ctx).pop(),
      //   child: Text('Got It!', style: TextStyle(color: Colors.black),),
      // ),
    ],
  );
}

Widget profileCustomAlertDialog(
    String btnMessage,
    ctx,
    void onGotIt(),
    Map<String, dynamic> decodedToken,
    double wid,
    ) {
  return AlertDialog(
    actionsPadding: EdgeInsets.symmetric(vertical:10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    // icon: Center(child: alertIcon),
    // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
    // title: Text(
    //   "$title",
    //   textAlign: TextAlign.center,
    //   style: TextStyle(fontWeight: FontWeight.bold),
    // ),
    content: Container(
      height: wid>=600?100:200,
      padding: EdgeInsets.only(top: 5),
      child: Flex(
        direction: MediaQuery.of(ctx).size.width>=600?Axis.horizontal:Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: SvgPicture.asset(
                'images/007-boy-2.svg',
                semanticsLabel: 'Acme Logo'
            ),
          ),
          SizedBox(
            width: 20,
            height: 10,
          ),
          Container(
            width: 200,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: wid>=600?CrossAxisAlignment.start:CrossAxisAlignment.center,
              children: [
                Text("${decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                Flexible(child: Tooltip(message: "${decodedToken["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"]}".replaceAll("[", "").replaceAll("]", ""), child: Text(overflow: TextOverflow.ellipsis,"${decodedToken["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"]}".replaceAll("[", "").replaceAll("]", ""), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),))),
                SizedBox(
                  height: 10,
                ),
                Text("${decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey.shade800),),
              ],
            ),
          ),
        ],
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowButtonSpacing: 8.0,
    actions: [
      Column(
        children: [
          GestureDetector(
            onTap: () {
              onGotIt();
              // Navigator.of(ctx).pop();
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                  child: Text(
                    '$btnMessage',
                    style: TextStyle(
                        color: bColor, fontSize: 15, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ],
      ),
      // TextButton(
      //   onPressed: () => Navigator.of(ctx).pop(),
      //   child: Text('Got It!', style: TextStyle(color: Colors.black),),
      // ),
    ],
  );
}

Widget returnInfoAlertDialog(double wid, double hei, bool isBigScreen,
    String btnMessage, ctx, void onGotIt(), ItemsPagnationResponse orderResponse, List<ReturnResponse>? orderDetailsResponse, ScrollController scrollController1, ScrollController scrollController2) {
  // print(orderDetailsResponse?[1].id);
  return AlertDialog(
    actionsPadding: EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    // icon: alertIcon,
    // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
    // title: Text(
    //   "$title",
    //   textAlign: TextAlign.center,
    // ),
    content: Container(
      width: wid,
      height: hei,
      child: Column(
        children: [
          Text("#${orderResponse.id}", style: TextStyle(fontSize: subTitleOne, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 30,
            child: Flex(
              direction: isBigScreen?Axis.horizontal:Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Issue Date:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.createdAt.split("T")[0]}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Required Date:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.date.split("T")[0]}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 30,
            child: Flex(
              direction: isBigScreen?Axis.horizontal:Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Customer:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.customerText}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Representative:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.addedBy}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 30,
            child: Flex(
              direction: isBigScreen?Axis.horizontal:Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.status==1?"Approved":"Pending"}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: isBigScreen?(hei-150)/2:(hei)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Note:", style: TextStyle(color: Colors.black54, fontSize: 12),),
                        Text("${orderResponse.note==""?"Empty":orderResponse.note}", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: btnColor.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black54),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: (hei-10)/4,
                      child: Text("Description", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                  Container(
                      width: (hei-10)/4,
                      child: Text("Subtotal", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                  Container(
                      width: (hei-10)/4,
                      child: Text("Quantity", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                  Container(
                      width: (hei-10)/4,
                      child: Text("Reason", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: orderDetailsResponse?.length,
                itemBuilder: (ctx, index){
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.grey),
                        )
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: scrollController2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: (hei-10)/4,
                              child: Text("${orderDetailsResponse?[index].productText}", style: TextStyle(fontSize: 10),)),
                          Container(
                              width: (hei-10)/4,
                              child: Text("${orderDetailsResponse?[index].subtotal}", style: TextStyle(fontSize: 10),)),
                          Container(
                              width: (hei-10)/4,
                              child: Text("${orderDetailsResponse?[index].quantity}", style: TextStyle(fontSize: 10),)),
                          Container(
                              width: (hei-10)/4,
                              child: Text("${orderDetailsResponse?[index].reason}", style: TextStyle(fontSize: 10),)),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Qty:", style: TextStyle(color: Colors.black54),),
                      Text("${orderDetailsResponse?.length}"),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Total:", style: TextStyle(color: Colors.black54),),
                      Text("${orderResponse.total}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    // Row(
    //   children: [
    //     Flexible(
    //       child: Column(
    //         children: [
    //           Row(
    //             children: [
    //               Container(
    //                 width: isBigScreen?50:25,
    //                 height: isBigScreen?50:25,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.shade100,
    //                   borderRadius: BorderRadius.all(
    //                     Radius.circular(10),
    //                   ),
    //                 ),
    //               ),
    //               Column(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Text("Order ID"),
    //                       Text("Order ID"),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // ),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowButtonSpacing: 8.0,
    actions: [
      GestureDetector(
        onTap: () {
          onGotIt();
          // Navigator.of(ctx).pop();
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xff606060),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          child: Center(
              child: Text(
                '$btnMessage',
                style: TextStyle(color: bColor, fontSize: 15),
              )),
        ),
      ),
      // TextButton(
      //   onPressed: () => Navigator.of(ctx).pop(),
      //   child: Text('Got It!', style: TextStyle(color: Colors.black),),
      // ),
    ],
  );
}