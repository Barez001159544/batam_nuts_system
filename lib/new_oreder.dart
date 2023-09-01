import 'dart:async';
import 'dart:convert';
import 'package:bn_sl/models/order_details_response.dart';
import 'package:bn_sl/models/order_details_view.dart';
import 'package:bn_sl/models/order_response.dart';
import 'package:bn_sl/providers/get_token.dart';
import 'package:bn_sl/services/general_service/general.dart';
import 'package:bn_sl/services/login/auth.dart';
import 'package:bn_sl/services/order_service/order.dart';
import 'package:bn_sl/services/product_service/product.dart';
import 'package:bn_sl/user_details.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:bn_sl/services/customer/get_customer.dart';
import 'package:bn_sl/models/customer_response.dart';
import 'package:bn_sl/models/general_response.dart';
import 'package:bn_sl/models/product_response.dart';
import 'package:bn_sl/services/customer_service/customer.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({Key? key}) : super(key: key);

  @override
  State<NewOrder> createState() => _NewOrderState();
}

List<String?> items = [];
List<CustomerResponse> customerList=[];
List<String> orderno = ["OR-"];
List<String> _updateOrderno = [];
bool ifSelected = true;
CustomerResponse? selectedCustomer;//="کانی"; //="کانی";
bool showValidationToast=false;
String vEMessage="";

List numberofQty = [];
List numberofPrice = [];
List<OrderDetailsView> orderDetails = [];
List<int> odID = [];
late OrderDetailsView orderDetail;
List<CustomerResponse>? _customers = [];
List<ProductResponse> productsView = [];
List<GeneralResponse>? _orderno = [];
late OrderResponse _saveOrder;
String searchQuery = "";
bool showM = false;
late Map<String, dynamic> decodedToken;

class _NewOrderState extends State<NewOrder> {
  late String? _token;
  tokenDecoder() async{
    _token=await Auth().ReadToken();
    Map<String, dynamic> payload = Jwt.parseJwt(_token!);
    print(payload);
    return payload;
  }
  product() {
    (() async {
      Product search = new Product();
      setState(() {
        productsView!.clear();
      });
      productsView = (await search?.Get(1, false, searchQuery))!;
      setState(() {
      });

      // if (productsView!.isEmpty) {
      //   setState(() {
      //     (() async {
      //       productsView = await search?.Get(1, false, searchQuery);
      //     })();
      //   });
      //   // productsView?.forEach((name) {
      //   //   print(
      //   //       "${name.sku}-${name.name}-${name.image}-${name.quantityOnHand}-${name.price}");
      //   //   setState(() {});
      //   // });
      // } else {
      //   print("Is Null.");
      // }
    })();
  }

  customers() {
    (() async {
      print("-------------------");
      Customer customer = new Customer();
      customerList = (await customer.Get())!;
      setState(() {
        //
      });
      print("---------------------");
    })();
  }

  orderNo() {
    (() async {
      print("-------------------");
      General ordernomber = new General();
      _orderno = await ordernomber.Get();
      // _updateOrderno= await ordernomber();
      if (_orderno != null) {
        _orderno?.forEach((name) {
          print(name.value);
          setState(() {
            orderno[0] = "OR-${name.value}";
            // var request = new GeneralResponse(name.id, name.name, name.value);
            // _updateOrderno= await ordernomber.Put(name.id, name.name, "${(int.parse(name.value)+1)}");
          });
        }); //1, "OrderCount", "${int.parse(orderno[0])+1}"
        // var request = new GeneralResponse(1, "OrderCount", "${int.parse(orderno[0])+1}");
        // _orderno2= await ordernomber.Put(request);
        // _updateOrderno[0]=
      } else {
        print("Is Null.");
      }
      print("---------------------");
    })();
  }

  updateOrderNo() {
    (() async {
      print("-------------------");
      General ordernomber = new General();
      var request = new GeneralResponse(
          1, "OrderCount", "${int.parse(orderno[0].split("-")[1])+1}");
      _orderno = await ordernomber.Put(request);
      // _orderno= await ordernomber.Get();
      // _updateOrderno= await ordernomber();
      // if(_orderno != null) {
      //   _orderno?.forEach((name) {
      //     print(name.value);
      //     setState(()  {
      //       orderno[0]=name.value;
      // var request = new GeneralResponse(name.id, name.name, name.value);
      // _updateOrderno= await ordernomber.Put(name.id, name.name, "${(int.parse(name.value)+1)}");
      //   });
      // });//1, "OrderCount", "${int.parse(orderno[0])+1}"

      // _updateOrderno[0]=
      // }else {
      //   print("Is Null.");
      // }
      print("---------------------");
    })();
  }
  void hideMessage(){
    Future.delayed(Duration(seconds: 10)).then((value) {
      if(this.mounted){
        setState(() {
          showValidationToast=false;
          print("DOne");
        });
      }
      vEMessage="";
    });
  }
showSaveConfirmation(){
  if (selectedCustomer == null) {
    print("it is null");
    setState(() {
      showValidationToast=true;
      vEMessage="Invalid Customer!";
    });
    hideMessage();
    // Future.delayed(Duration(seconds: 3)).then((value) => null){
    //   if(this.mounted)
    //     setState((){
    //       _isContainerVisible = false;
    //     });
    // });
  } else if (_orderNomberController.text.isEmpty) {
    print("OR is Empty");
    setState(() {
      showValidationToast=true;
      vEMessage="Invalid Order Number!";
    });
    hideMessage();
  } else if (orderDetails.isEmpty) {
    print("OD is Empty");
    setState(() {
      showValidationToast=true;
      vEMessage="No Item Selected!";
    });
    hideMessage();
  }else {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return cofirmationCustomAlertDialog(
            FaIcon(FontAwesomeIcons.checkDouble, size: 60, color: btnColor,),
            // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
            "Save Order", "Are you sure you want to save this order?", "Cancel", "Proceed", context, () {
            saveOrder();
            _orderNomberController.clear();
            _noteController.clear();
            updateOrderNo();
            selectedCustomer=null;
            // orderDetails.clear();
            searchQuery="";
            product();
            int incON = (int.parse(orderno[0].split("-")[1]));
            if (incON != null)
              incON++;orderno[0] = "OR-$incON";
            print(_orderNomberController.text);
            Navigator.of(context, rootNavigator: true).pop();
          },(){
            Navigator.of(context, rootNavigator: true).pop();
          },
          );
        });
  }
}

  showDiscardConfirmation(){
      showDialog(
          context: context,
          builder: (BuildContext contex) {
            return cofirmationCustomAlertDialog(
              FaIcon(FontAwesomeIcons.triangleExclamation, size: 60, color: Color(0xfff04372),),
              // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
              "Discard Order", "Are you sure you want to discard?", "Cancel", "Proceed", context, () {
              // saveOrder();
              _orderNomberController.clear();
              _noteController.clear();
              selectedCustomer=null;
              orderDetails.clear();
              searchQuery="";
              product();
              Navigator.of(context, rootNavigator: true).pop();
            },(){
              Navigator.of(context, rootNavigator: true).pop();
            },
            );
          });

  }
  saveOrder() async{
    String theDate = "${"${DateTime.now()}".replaceAll(" ", "T")}";
    // (() async {
        var request = new OrderResponse(
            "${Provider.of<GetToken>(context, listen: false).dToken['fullname']}",
            theDate,
            theDate,
            theDate,
            true,
            0,
            "${_orderNomberController.text}",
            theDate,
            1,
            "${_noteController.text}",
            orderDetails.map((item) => item.price).reduce((a, b) => a + b),
            selectedCustomer!.id,
            int.parse("${Provider.of<GetToken>(context, listen: false).dToken['warehouseid']}"),
            selectedCustomer!.name!,
            "${Provider.of<GetToken>(context, listen: false).dToken['fullname']}",
            "${Provider.of<GetToken>(context, listen: false).dToken['id']}");
        Order saveOrder = new Order();
        _saveOrder = (await saveOrder.Upload(request))!;
        print(orderDetails);
        if (_saveOrder.id > 0) {
          for (var e in orderDetails) {
            print("Product is >>${e.productId}");
            print("Order Id>>${_saveOrder.id}");
            var x= OrderDetailsResponse("Sivar", theDate, theDate, theDate, true, 0, _saveOrder.id, e.productId, e.productText, e.price, e.quantity, e.subtotal);
            var oDetails= new OrderDetailsResponse("sivar", theDate, theDate, theDate, true, 0, _saveOrder.id, e.productId, e.productText, e.price, e.quantity, e.subtotal);
            OrderDetails orderD= OrderDetails();
            orderD.OrderDetailsUpload(oDetails);
            print(orderD);
          }
        }
        orderDetails.clear();

      // _updateOrderno= await ordernomber();
      // if(_orderno != null) {
      //   _orderno?.forEach((name) {
      //     print(name.value);
      //     setState(()  {
      //       orderno[0]="OR-${name.value}";
      // var request = new GeneralResponse(name.id, name.name, name.value);
      // _updateOrderno= await ordernomber.Put(name.id, name.name, "${(int.parse(name.value)+1)}");
      //   });
      // });//1, "OrderCount", "${int.parse(orderno[0])+1}"
      // var request = new GeneralResponse(1, "OrderCount", "${int.parse(orderno[0])+1}");
      // _orderno2= await ordernomber.Put(request);
      // _updateOrderno[0]=
      // }else {
      //   print("Is Null.");
      // }
      print("---------------------");
    // })();
  }

  late ScrollController scrollController;
  late ScrollController scrollController2;
  _scrollListener() {
    setState(() {
      scrollController2.jumpTo(
        scrollController.offset,
      );
    });
  }

  void initState() {
    product();
    orderNo();
    customers();
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);
    scrollController2 = ScrollController(initialScrollOffset: 0);
    scrollController.addListener(() {
      _scrollListener();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GetToken>(context, listen: false).readToken();
    });
    // (() async {
    //   decodedToken= await tokenDecoder();
    //   print("${decodedToken['fullname']}<<<<<<<<<<<<<");
    // })();
    // overallItems.isEmpty?Center(
    // child: Overlay(
    //   initialEntries: [
    //     OverlayEntry(
    //       builder: (BuildContext context) {
    //         return Container(
    //           width: 80,
    //           height: 80,
    //           child: CircularProgressIndicator(
    //             backgroundColor: Colors.transparent,
    //             color: btnColor,
    //             strokeWidth: 8,
    //           ),
    //         );
    //       },
    //     ),
    //   ],
    // ),
    // ):Container();
  }
  // @override
  // void didUpdateWidget(covariant NewOrder oldWidget) {
  //   //
  //   super.didUpdateWidget(oldWidget);
  //   product();
  //   customers();
  //   orderNo();
  //   super.initState();
  //   scrollController = ScrollController(initialScrollOffset: 0);
  //   scrollController2 = ScrollController(initialScrollOffset: 0);
  //   scrollController.addListener(() {
  //     _scrollListener();
  //   });
  //   (() async {
  //     decodedToken= await tokenDecoder();
  //     print("${decodedToken['fullname']}<<<<<<<<<<<<<");
  //   })();
  // }

  //-------------------------------
  int initialValue = 1;
  TextEditingController _qtyController = TextEditingController(text: "1");
  TextEditingController _noteController = TextEditingController();
  TextEditingController _orderNomberController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // _qtyController.text = "1";
    BottomDrawerController _controller = BottomDrawerController();
    double wid = MediaQuery.of(context).size.width;
    double hei = wid <= widthResponsiveness
        ? MediaQuery.of(context).size.height - 60
        : MediaQuery.of(context).size.height;
    bool isBigScreen = wid <= widthResponsiveness ? false : true;
    double firstContainerWidth = wid <= widthResponsiveness ? wid : wid * 0.7;
    SystemChrome.setPreferredOrientations([
      isBigScreen?DeviceOrientation.landscapeLeft:DeviceOrientation.portraitUp,
      isBigScreen?DeviceOrientation.landscapeRight:DeviceOrientation.portraitUp,
    ]);
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // actions: [
          //   isBigScreen
          //       ? Container()
          //       : IconButton(
          //           onPressed: () {
          //             print("object");
          //             setState(() {
          //               showM = showM == true ? false : true;
          //             });
          //           },
          //           icon: FaIcon(
          //             showM == false
          //                 ? FontAwesomeIcons.gripVertical
          //                 : FontAwesomeIcons.xmark,
          //             color: Colors.black,
          //           ),
          //           tooltip: "Open Items Tab",
          //         ),
          // ],
          centerTitle: true,
          title: Center(
            child: Text(
              "New Order",
              style:
                  TextStyle(color: Colors.black54, fontSize: titleOne - 10),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.grey.shade300,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
              print("back");
            },
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                color: btnColorHover,
                onRefresh: () {
                  return Future.delayed(
                    Duration(seconds: 1),
                        () {
                      setState(() {
                        product();
                        customers();
                        orderNo();
                      });

                      // showing snackbar
                      // _scaffoldKey.currentState.showSnackBar(
                      //   SnackBar(
                      //     content: const Text('Page Refreshed'),
                      //   ),
                      // );
                    },
                  );
                },
                child: Container(
                  child:
                      // overallItems.isEmpty?Container(
                      //   child: LinearProgressIndicator(
                      //     backgroundColor: Colors.transparent,
                      //     color: btnColor,
                      //   ),
                      // ):
                      Row(
                    children: [
                      Container(
                        width: firstContainerWidth,
                        // color: Colors.blue,
                        child: Column(
                          children: [
                            Flexible(
                              child: Container(
                                color: Colors.grey.shade300,
                                width: firstContainerWidth,
                                // height: isBigScreen ? hei * 0.3 - 45 : 250,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: isBigScreen ? hei * 0.3 - 65 : 250,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: bColor,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              child: Flex(
                                                direction: isBigScreen
                                                    ? Axis.horizontal
                                                    : Axis.vertical,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Order No."),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      generateNumberWithBtn(
                                                        isBigScreen
                                                            ? firstContainerWidth *
                                                                    0.5 -
                                                                20
                                                            : firstContainerWidth,
                                                        40,
                                                        _orderNomberController,
                                                        () {
                                                          setState(() {
                                                            // orderNo();
                                                            int incON = (int.parse(orderno[0].split("-")[1]));
                                                            _orderNomberController.text = "OR-$incON";
                                                            print(_orderNomberController.text);
                                                            // if (incON != null)
                                                            //   incON++;orderno[0] = "OR-$incON";
                                                            // incON=(int.parse(orderno[0].split("-")[1]))+1;
                                                            // updateOrderNo();
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Customer"),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      customDropDownMenu(
                                                          isBigScreen
                                                              ? firstContainerWidth *
                                                                      0.5 -
                                                                  30
                                                              : firstContainerWidth,
                                                          40,
                                                          customerList,
                                                          selectedCustomer?.name, (val) {
                                                        setState(() {
                                                          selectedCustomer =customerList?.firstWhere((e) => e.name==val);
                                                              //val;
                                                        });
                                                      }, context),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Note"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                cTextfield(firstContainerWidth, 40,
                                                    (val) {}, _noteController, "", TextDirection.rtl)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: firstContainerWidth,
                              height:
                                  isBigScreen ? hei * 0.7 - 11 : hei * 0.7 - 75,
                              color: Colors.grey.shade300,
                              padding: EdgeInsets.all(10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: bColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade300,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                      child: isBigScreen == false
                                          ? SingleChildScrollView(
                                              controller: scrollController,
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 0.0, 10.0, 0.0),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      width: 100,
                                                      // color: Colors.blue,
                                                      child: Text("SKU")),
                                                  Container(
                                                      width: 100,
                                                      // color: Colors.blue,
                                                      child: Text("Product")),
                                                  Container(
                                                      width: 100,
                                                      // color: Colors.blue,
                                                      child: Text("Available")),
                                                  Container(
                                                      width: 100,
                                                      // color: Colors.blue,
                                                      child: Text("Price")),
                                                  Container(
                                                      width: 100,
                                                      // color: Colors.blue,
                                                      child: Text("Qty")),
                                                  Container(
                                                      width: 100,
                                                      // color: Colors.blue,
                                                      child: Text("Subtotal")),
                                                  GestureDetector(
                                                    onTap: () {
                                                      print("delete");
                                                      setState(() {
                                                        orderDetails.clear();
                                                        numberofQty.clear();
                                                        numberofPrice.clear();
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.grey.shade300,
                                                        borderRadius:
                                                            BorderRadius.all(
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
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: Text("SKU")),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: Text("Product")),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: Text("Available")),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: Text("Price")),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: Text("Qty")),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: Text("Subtotal")),
                                                GestureDetector(
                                                  onTap: () {
                                                    print("delete");
                                                    setState(() {
                                                      orderDetails.clear();
                                                      odID.clear();
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.all(
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
                                            ),
                                    ),
                                    // Flexible(
                                    //   child: orderDetails.length != 0
                                    //       ? ListView.builder(
                                    //           itemCount: orderDetails.length,
                                    //           itemBuilder: (ctx, index) {
                                    //             return Container(
                                    //               padding: EdgeInsets.symmetric(
                                    //                   horizontal: 20),
                                    //               height: 60,
                                    //               decoration: BoxDecoration(
                                    //                 border: Border(
                                    //                   top: BorderSide(
                                    //                       width: 1,
                                    //                       color: Colors.grey.shade300,
                                    //                       style: BorderStyle.solid),
                                    //                 ),
                                    //               ),
                                    //               child: isBigScreen==false?SingleChildScrollView(
                                    //                 controller: scrollController2,
                                    //                 padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                    //                 scrollDirection: Axis.horizontal,
                                    //                 child: Row(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment
                                    //                           .spaceBetween,
                                    //                   children: [
                                    //                     Container(
                                    //                       width:100,
                                    //                       child: Text(
                                    //                         "${(orderDetails[index]).productId}",
                                    //                         style:
                                    //                             TextStyle(fontSize: 12),
                                    //                       ),
                                    //                     ),
                                    //                     Container(
                                    //                       width: 100,
                                    //                       child: Text(
                                    //                         "${(orderDetails[index]).productText}",
                                    //                         style:
                                    //                             TextStyle(fontSize: 12),
                                    //                       ),
                                    //                     ),
                                    //                     Container(
                                    //                       width: 100,
                                    //                       child: Text(
                                    //                         "${(orderDetails[index]).available}",
                                    //                         style:
                                    //                             TextStyle(fontSize: 12),
                                    //                       ),
                                    //                     ),
                                    //                     Container(
                                    //                       width: 100,
                                    //                       child: Text(
                                    //                         "${(orderDetails[index]).quantity}",
                                    //                         style:
                                    //                             TextStyle(fontSize: 12),
                                    //                       ),
                                    //                     ),
                                    //                     Container(
                                    //                       padding: EdgeInsets.only(right: 60),
                                    //                       width: 100,
                                    //                       child: Container(
                                    //                         width: 40,
                                    //                         height: 40,
                                    //                         decoration: BoxDecoration(
                                    //                           color: Colors.grey.shade300,
                                    //                           borderRadius:
                                    //                               BorderRadius.all(
                                    //                             Radius.circular(5),
                                    //                           ),
                                    //                         ),
                                    //                         child: Center(
                                    //                           child: TextField(
                                    //                             // initialValue: "$initialValue",
                                    //                             controller:
                                    //                                 TextEditingController(
                                    //                                     text:
                                    //                                         "${numberofQty[index]}"),
                                    //                             keyboardType:
                                    //                                 TextInputType.number,
                                    //                             textAlign:
                                    //                                 TextAlign.center,
                                    //                             decoration:
                                    //                                 InputDecoration(
                                    //                               border:
                                    //                                   InputBorder.none,
                                    //                             ),
                                    //                             onSubmitted: (val) {
                                    //                               setState(() {
                                    //                                 if (int.parse(val) <= orderDetails[index].available) {
                                    //                                   orderDetails[index].quantity = double.parse(val);
                                    //                                   orderDetails[index].price = int.parse(val) * double.parse("${orderDetails[index].price}");
                                    //                                   // print("${numberofQty[index]}, ${orderDetails[index].split("-")[3]}");
                                    //                                 } else if (val == "" || val.isEmpty || val.length == 0) {
                                    //                                   print("Empty!");
                                    //                                 } else {
                                    //                                   print("bad");
                                    //                                   // AlertDialog(
                                    //                                   //   backgroundColor: Colors.blue,
                                    //                                   //   title: Text("Alert"),
                                    //                                   //   icon: Icon(Icons.error_outline_rounded),
                                    //                                   // );
                                    //                                   showDialog(
                                    //                                       context:
                                    //                                           context,
                                    //                                       builder:
                                    //                                           (BuildContext
                                    //                                               contex) {
                                    //                                         return customAlertDialog(
                                    //                                             "Invalid Entry",
                                    //                                             "Quantity should not be \nmore than ${orderDetails[index].available} KG",
                                    //                                             "Got it!",
                                    //                                             context);
                                    //                                       });
                                    //                                 }
                                    //                               });
                                    //                               print(
                                    //                                   "$val qty submitted ${numberofQty[index]}");
                                    //                             },
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                     Container(
                                    //                       width: 100,
                                    //                       child: Text(
                                    //                         "${numberofPrice[index]} IQD",
                                    //                         style:
                                    //                             TextStyle(fontSize: 12),
                                    //                       ),
                                    //                     ),
                                    //                     GestureDetector(
                                    //                       onTap: () {
                                    //                         print("delete $index item");
                                    //                         setState(() {
                                    //                           orderDetails
                                    //                               .removeAt(index);
                                    //                           numberofQty
                                    //                               .removeAt(index);
                                    //                           numberofPrice
                                    //                               .removeAt(index);
                                    //                         });
                                    //                       },
                                    //                       child: Container(
                                    //                         width: 40,
                                    //                         height: 40,
                                    //                         decoration: BoxDecoration(
                                    //                           color:
                                    //                               Colors.grey.shade300,
                                    //                           borderRadius:
                                    //                               BorderRadius.all(
                                    //                             Radius.circular(10),
                                    //                           ),
                                    //                         ),
                                    //                         child: Icon(
                                    //                           Icons.delete_rounded,
                                    //                           size: 20,
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ):Row(
                                    //                 mainAxisAlignment:
                                    //                 MainAxisAlignment
                                    //                     .spaceBetween,
                                    //                 children: [
                                    //                   // Container(
                                    //                   //   width:100,
                                    //                   //   child: Text(
                                    //                   //     "${(orderDetails[index]).split("-")[0]}",
                                    //                   //     style:
                                    //                   //     TextStyle(fontSize: 12),
                                    //                   //   ),
                                    //                   // ),
                                    //                   // Container(
                                    //                   //   width: 100,
                                    //                   //   child: Text(
                                    //                   //     "${(orderDetails[index]).split("-")[1]}",
                                    //                   //     style:
                                    //                   //     TextStyle(fontSize: 12),
                                    //                   //   ),
                                    //                   // ),
                                    //                   // Container(
                                    //                   //   width: 100,
                                    //                   //   child: Text(
                                    //                   //     "${(orderDetails[index]).split("-")[3]}",
                                    //                   //     style:
                                    //                   //     TextStyle(fontSize: 12),
                                    //                   //   ),
                                    //                   // ),
                                    //                   // Container(
                                    //                   //   width: 100,
                                    //                   //   child: Text(
                                    //                   //     "${(orderDetails[index]).split("-")[4]}",
                                    //                   //     style:
                                    //                   //     TextStyle(fontSize: 12),
                                    //                   //   ),
                                    //                   // ),
                                    //                   // Container(
                                    //                   //   padding: EdgeInsets.only(right: 60),
                                    //                   //   width: 100,
                                    //                   //   child: Container(
                                    //                   //     width: 40,
                                    //                   //     height: 40,
                                    //                   //     decoration: BoxDecoration(
                                    //                   //       color: Colors.grey.shade300,
                                    //                   //       borderRadius:
                                    //                   //       BorderRadius.all(
                                    //                   //         Radius.circular(5),
                                    //                   //       ),
                                    //                   //     ),
                                    //                   //     child: Center(
                                    //                   //       child: TextField(
                                    //                   //         // initialValue: "$initialValue",
                                    //                   //         controller:
                                    //                   //         TextEditingController(
                                    //                   //             text:
                                    //                   //             "${numberofQty[index]}"),
                                    //                   //         keyboardType:
                                    //                   //         TextInputType.number,
                                    //                   //         textAlign:
                                    //                   //         TextAlign.center,
                                    //                   //         decoration:
                                    //                   //         InputDecoration(
                                    //                   //           border:
                                    //                   //           InputBorder.none,
                                    //                   //         ),
                                    //                   //         onSubmitted: (val) {
                                    //                   //           setState(() {
                                    //                   //             if (int.parse(val) <= double.parse(orderDetails[index].split("-")[3])) {
                                    //                   //               numberofQty[index] = int.parse(val);
                                    //                   //               numberofPrice[index] = int.parse(val) * double.parse("${overallItems[index].split("-")[4]}");
                                    //                   //               print("${numberofQty[index]}, ${orderDetails[index].split("-")[3]}");
                                    //                   //             } else if (val == "" || val.isEmpty || val.length == 0) {
                                    //                   //               print("Empty!");
                                    //                   //             } else {
                                    //                   //               print("bad");
                                    //                   //               // AlertDialog(
                                    //                   //               //   backgroundColor: Colors.blue,
                                    //                   //               //   title: Text("Alert"),
                                    //                   //               //   icon: Icon(Icons.error_outline_rounded),
                                    //                   //               // );
                                    //                   //               showDialog(
                                    //                   //                   context:
                                    //                   //                   context,
                                    //                   //                   builder:
                                    //                   //                       (BuildContext
                                    //                   //                   contex) {
                                    //                   //                     return customAlertDialog(
                                    //                   //                         "Invalid Entry",
                                    //                   //                         "Quantity should not be \nmore than ${orderDetails[index].split("-")[3]} KG.",
                                    //                   //                         "Got it!",
                                    //                   //                         context);
                                    //                   //                   });
                                    //                   //             }
                                    //                   //           });
                                    //                   //           print(
                                    //                   //               "$val qty submitted ${numberofQty[index]}");
                                    //                   //         },
                                    //                   //       ),
                                    //                   //     ),
                                    //                   //   ),
                                    //                   // ),
                                    //                   // Container(
                                    //                   //   width: 100,
                                    //                   //   child: Text(
                                    //                   //     "${numberofPrice[index]} IQD",
                                    //                   //     style:
                                    //                   //     TextStyle(fontSize: 12),
                                    //                   //   ),
                                    //                   // ),
                                    //                   // GestureDetector(
                                    //                   //   onTap: () {
                                    //                   //     print("delete $index item");
                                    //                   //     setState(() {
                                    //                   //       orderDetails
                                    //                   //           .removeAt(index);
                                    //                   //       numberofQty
                                    //                   //           .removeAt(index);
                                    //                   //       numberofPrice
                                    //                   //           .removeAt(index);
                                    //                   //     });
                                    //                   //   },
                                    //                   //   child: Container(
                                    //                   //     width: 40,
                                    //                   //     height: 40,
                                    //                   //     decoration: BoxDecoration(
                                    //                   //       color:
                                    //                   //       Colors.grey.shade300,
                                    //                   //       borderRadius:
                                    //                   //       BorderRadius.all(
                                    //                   //         Radius.circular(10),
                                    //                   //       ),
                                    //                   //     ),
                                    //                   //     child: Icon(
                                    //                   //       Icons.delete_rounded,
                                    //                   //       size: 20,
                                    //                   //     ),
                                    //                   //   ),
                                    //                   // ),
                                    //                 ],
                                    //               ),
                                    //             );
                                    //           })
                                    //       : Center(
                                    //           child: Container(
                                    //             width: isBigScreen?300:200,
                                    //             height: isBigScreen?300:200,
                                    //             // decoration: BoxDecoration(
                                    //             //   image: DecorationImage(
                                    //             //       image: AssetImage("images/9650074_7612.jpg"),
                                    //             //   ),
                                    //             // ),
                                    //             child: Center(child: FaIcon(FontAwesomeIcons.boxOpen, size: 150, color: Colors.black54,)),
                                    //           ),
                                    //           // Icon(
                                    //           //   Icons.cancel_presentation_rounded,
                                    //           //   size: 200,
                                    //           //   color: Colors.grey,
                                    //           // ),
                                    //         ),
                                    // ),
                                    selectedItemsScreen(orderDetails, isBigScreen,
                                        scrollController2, (val, index) {
                                      setState(() {
                                        if (int.parse(val) <=
                                            orderDetails[index].available) {
                                          orderDetails[index].quantity =
                                              double.parse(val);
                                          orderDetails[index].price = int.parse(
                                                  val) *
                                              double.parse(
                                                  "${orderDetails[index].price}");
                                          // print("${numberofQty[index]}, ${orderDetails[index].split("-")[3]}");
                                        } else if (val == "" ||
                                            val.isEmpty ||
                                            val.length == 0) {
                                          print("Empty!");
                                        } else {
                                          print("bad");
                                          // AlertDialog(
                                          //   backgroundColor: Colors.blue,
                                          //   title: Text("Alert"),
                                          //   icon: Icon(Icons.error_outline_rounded),
                                          // );
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext contex) {
                                                return customAlertDialog(
                                                    Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
                                                    "Invalid Entry",
                                                    "Quantity should not be \nmore than ${orderDetails[index].available} KG",
                                                    "Got it!",
                                                    context, (){
                                                  Navigator.of(context).pop();
                                                });
                                              });
                                        }
                                      });
                                    }, (index) {
                                      setState(() {
                                        print(
                                            "${orderDetails[index].productText}");
                                        orderDetails.removeAt(index);
                                      });
                                    }),
                                    Container(
                                      height: isBigScreen ? 60 : 90,
                                      width: isBigScreen ? wid * 0.68 : wid,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade300,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                      child: Flex(
                                        direction: isBigScreen
                                            ? Axis.horizontal
                                            : Axis.vertical,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Qty",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${orderDetails.length}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "Total",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${orderDetails.length != 0 ? orderDetails.map((item) => item.price).reduce((a, b) => a + b) : 0} IQD",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: isBigScreen?0:20,
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  print("Submit");
                                                  // updateOrderNo();
                                                  // saveOrder();
                                                  showSaveConfirmation();
                                                },
                                                child: Container(
                                                  width: isBigScreen
                                                      ? 240
                                                      : wid * 0.45,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    btnColor, //Color(0xff11C2C9),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                        "Submit",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDiscardConfirmation();
                                                  print("Discard");
                                                },
                                                child: Container(
                                                  width: isBigScreen
                                                      ? 100
                                                      : wid * 0.3,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffF04372),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                        "Discard",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isBigScreen
                          ? productScreen(wid, () {
                              //onSubmit
                            }, (val) {
                              if (val.length % 3 == 0 || val.length == 0) {
                                setState(() {
                                  // overallItems.clear();
                                  searchQuery = searchController.text;
                                  print("${searchController.text}KKKKKKKKKKKKKK");
                                  product();
                                });
                              }
                              print("value: ${val == '' ? "g" : "N"}----");
                            }, (index) {
                              //onItemTap
                              // print("index${_search![index].name}");

                        var item=orderDetails.firstWhereOrNull(((x) => x.productId==productsView?[index].id));
                        var ele=orderDetails.contains(item);

                        if(ele){
                          setState(() {
                            item?.quantity++;
                            item?.price += productsView![index].price;
                          });
                        }else{
                          setState(() {
                            var product = productsView![index];
                            orderDetail = OrderDetailsView(
                                "",
                                "",
                                "",
                                "",
                                true,
                                0,
                                0,
                                product.id,
                                product.name,
                                product.price,
                                1,
                                product.price,
                                product.quantityAvailable,
                                product.sku!,
                            );
                            orderDetails.add(orderDetail);
                            for(var a in orderDetails){
                              print(a.productId);
                            }
                          });
                        }


                            }, productsView!, true, searchController)
                          : Container(),
                    ],
                  ),
                ),
              ),
              isBigScreen?Container():buildBottomDrawer(context, productScreen(wid-200, () {
                //onSubmit
              }, (val) {
                if (val.length % 3 == 0 || val.length == 0) {
                  setState(() {
                    // overallItems.clear();
                    searchQuery = searchController.text;
                    print("${searchController.text}KKKKKKKKKKKKKK");
                  });
                  product();
                }
                print("value: ${val == '' ? "g" : "N"}----");
              }, (index) {
                //onItemTap
                // print("index${_search![index].name}");

                var item=orderDetails.firstWhereOrNull(((x) => x.productId==productsView?[index].id));
                var ele=orderDetails.contains(item);

                if(ele){
                  setState(() {
                    item?.quantity++;
                    item?.price += productsView![index].price;
                  });
                }else{
                  setState(() {
                    var product = productsView![index];
                    orderDetail = OrderDetailsView(
                        "",
                        "",
                        "",
                        "",
                        true,
                        0,
                        0,
                        product.id,
                        product.name,
                        product.price,
                        1,
                        product.price,
                        product.quantityAvailable,
                        product.sku!
                    );
                    orderDetails.add(orderDetail);
                    for(var a in orderDetails){
                      print(a.productId);
                    }
                  });
                }


              }, productsView!, isBigScreen, searchController), _controller),
              AnimatedOpacity(
                opacity: showValidationToast?1:0,
                duration: Duration(milliseconds: showValidationToast?0:500),
                child: validationErrorMessage(vEMessage),
              ),
              (customerList.isEmpty && productsView.isEmpty)?Center(
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    strokeAlign: 6,
                    // minHeight: 1,
                    backgroundColor: Colors.white,
                    color: btnColorHover,
                  ),
                ),
              ):Container(),
            ],
          ),
        ),
      ),
    );
  }

  void onIncrement(TextEditingController controller) {
    int currentValue = int.parse(controller.text);
    setState(() {
      currentValue++;
      controller.text = (currentValue).toString();
    });
  }
}
