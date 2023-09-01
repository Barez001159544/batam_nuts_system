import 'package:bn_sl/models/return_details_view.dart';
import 'package:bn_sl/models/return_response.dart';
import 'package:bn_sl/providers/get_token.dart';
import 'package:bn_sl/providers/customer_controller.dart';
import 'package:bn_sl/providers/product_controller.dart';
import 'package:bn_sl/return_heade_response.dart';
import 'package:bn_sl/services/customer_service/customer.dart';
import 'package:bn_sl/services/login/auth.dart';
import 'package:bn_sl/services/product_service/product.dart';
import 'package:bn_sl/services/return/i_return.dart';
import 'package:bn_sl/services/return/return.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'models/customer_response.dart';
import 'models/order_details_view.dart';
import 'models/product_response.dart';

class NewReturn extends StatefulWidget {
  const NewReturn({super.key});

  @override
  State<NewReturn> createState() => _NewReturnState();
}
DateTime reqDate= DateTime.now();
String searchQuery = "";
bool showM=false;
String reason="";
bool showValidationToast=false;
String vEMessage="";
List<CustomerResponse> customerList=[];
CustomerResponse? selectedCustomer;
List<ReturnDetailsSView> orderDetails = [];
List<ProductResponse> productsView = [];
late ReturnDetailsSView orderDetail;
ReturnHeadeResponse? rHeade;
ReturnResponse? returnedItems;
class _NewReturnState extends State<NewReturn> {
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
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
  product() {
    (() async {
      Product search = new Product();
      setState(() {
        productsView!.clear();
      });
      productsView = (await search?.Get(1, false, searchQuery))!;
      setState(() {
      });
      print(productsView?[0].price);
    })();
  }
  returnHeade() {
    (() async {
      print("-------------------");
      ReturnHeadeClass returnHeade = new ReturnHeadeClass();
      rHeade = await returnHeade.ReturnHeade(ReturnHeadeResponse("${Provider.of<GetToken>(context, listen: false).dToken["fullname"]}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", true, 0, 1, int.parse(Provider.of<GetToken>(context, listen: false).dToken["warehouseid"]), "${Provider.of<GetToken>(context, listen: false).dToken["id"]}", selectedCustomer!.id, orderDetails.map((item) => item.subtotal).reduce((a, b) => a + b) , "${selectedCustomer?.name}", "${_noteController.text}"));
      setState(() {
        //
      });
      print("${rHeade?.customerText}^^^^^^^^^^^^^^^^^^^^^^^^^^^^"); ///great
      ///
      ///
      // ReturnHeadeClass returnHeade = new ReturnHeadeClass();
      for (var e in orderDetails) {
        returnedItems = await returnHeade.Return(ReturnResponse(
            "${Provider.of<GetToken>(context, listen: false).dToken["fullname"]}",
            "${reqDate.toString().replaceAll(" ", "T")}",
            "${reqDate.toString().replaceAll(" ", "T")}",
            "${reqDate.toString().replaceAll(" ", "T")}",
            true,
            0,
            e.productId,
            e.productText,
            0,
            e.reason,
            e.quantity,
            e.price,
            e.subtotal,
            rHeade!.id,
        ));
      }

      orderDetails.clear();
      setState(() {
        //
      });
      print(returnedItems?.productText);
    })();
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
  showDiscardConfirmation(){
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return cofirmationCustomAlertDialog(
            FaIcon(FontAwesomeIcons.triangleExclamation, size: 60, color: Color(0xfff04372),),
            // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
            "Discard Order", "Are you sure you want to discard?", "Cancel", "Proceed", context, () {
            // saveOrder();
            _noteController.clear();
            selectedCustomer=null;
            orderDetails.clear();
            reqDate=DateTime.now();
            searchQuery="";
            product();
            Navigator.of(context, rootNavigator: true).pop();
          },(){
            Navigator.of(context, rootNavigator: true).pop();
          },
          );
        });

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
    } else if (reqDate.toString()==null) {
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
              // saveOrder();
              returnHeade();
              _noteController.clear();
              selectedCustomer=null;
              // orderDetails.clear();
              searchQuery="";
              product();
              Navigator.of(context, rootNavigator: true).pop();
            },(){
              Navigator.of(context, rootNavigator: true).pop();
            },
            );
          });
    }

  }
  Map<String, dynamic> decodedToken={};
  dynamic jwtToken;
  Future<dynamic> getDecodedToken(){
    jwtToken= Auth().ReadToken();
    print(jwtToken);
    return jwtToken;
  }
  dynamic returnedToken;
  @override
  void initState() {
    super.initState();
    customers();
    product();
    scrollController = ScrollController(initialScrollOffset: 0);
    scrollController2 = ScrollController(initialScrollOffset: 0);
    scrollController.addListener(() {
      _scrollListener();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GetToken>(context, listen: false).readToken();
      Provider.of<CustomerController>(context, listen: false).getAllCustomers();
      Provider.of<ProductController>(context, listen: false).getAllProducts();
    });
    // (() async{
    //   returnedToken = await getDecodedToken();
    //   // returnedCustomers= await getListOfCustomers();
    //   print("---------------------------");
    //   print(returnedToken);
    //   print("---------------------------");
    //   print("???????????????????????????????????");
    //   // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImM4M2Q3NDFjLTkyMTEtNDAwZi1hNmQyLTQ4NjU4MzZmNTFmZSIsIndhcmVob3VzZWlkIjoiMSIsImlzcmVwcmVzZW50YXRpdmUiOiJGYWxzZSIsImZ1bGxuYW1lIjoiaGltZGFkIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZW1haWxhZGRyZXNzIjoiaGltZGFkQHR3YW4uY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6ImhpbWRhZCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJTdG9jayIsIkRhc2hib2FyZCIsIk1hbmFnZXIiLCJSZXBvcnQiXSwibmJmIjoxNjg5MTUzOTAyLCJleHAiOjE2OTAzNjM1MDIsImlzcyI6Imh0dHA6Ly9iYXJlemF6YWQtMDAxLXNpdGUxLmN0ZW1wdXJsLmNvbS8iLCJhdWQiOiJodHRwOi8vYmFyZXphemFkLTAwMS1zaXRlMS5jdGVtcHVybC5jb20ifQ.l2MozDxev0ig5nRnWV-AQjgxqzA01chua1lRMtjV_uA";
    //   // decodedToken = Jwt.parseJwt("$returnedToken");
    //   print(decodedToken);
    //   print("+++++++++++++++++++++++++");
    //   // print(returnedCustomers);
    // })();
  }
  TextEditingController _noteController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  BottomDrawerController _controller = BottomDrawerController();
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = wid <= widthResponsiveness
        ? MediaQuery.of(context).size.height - 60
        : MediaQuery.of(context).size.height;
    bool isBigScreen = wid <= widthResponsiveness ? false : true;
    double firstContainerWidth = wid <= widthResponsiveness ? wid : wid * 0.7;
    return Consumer2<CustomerController, ProductController>(
        builder: (context, customerController, productController, child) {
      if (customerController.isLoading && productController.isLoading) {
        // return const Center(
        //   child: CircularProgressIndicator(
        //     backgroundColor: Colors.cyan,
        //     color: Colors.red,
        //   ),
        // );
      }
      // If loading is false then this code will show the list of todo item
      final customers = customerController.customerResponse;
      final pView= productController.productsView;
      return Expanded(
        child: Stack(
          children: [
            // SliderDrawer(
            //   key: _key,
            //   slideDirection: 	SlideDirection.RIGHT_TO_LEFT,
            //   appBar: SliderAppBar(
            //       appBarColor: Colors.white,
            //       title: Text('Title',
            //           style:
            //           const TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
            //   slider: Container(color: Colors.red),
            //   child: Container(color: Colors.amber),
            // ),
            SliderDrawer(
              key: _key,
              slideDirection: 	SlideDirection.RIGHT_TO_LEFT,
              appBar: null,
              sliderOpenSize: isBigScreen?400:0,
              slider: productScreen(wid-200, () {
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

                var item=orderDetails.firstWhereOrNull(((x) => x.productId==pView?[index].id));
                var ele=orderDetails.contains(item);

                if(ele){
                  setState(() {
                    item?.quantity++;
                    item?.subtotal += pView![index].price;
                  });
                }else{
                  setState(() {
                    var product = pView![index];
                    orderDetail = ReturnDetailsSView(
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
                      "",
                      1,
                      1,
                    );
                    orderDetails.add(orderDetail);
                    for(var a in orderDetails){
                      print(a.productId);
                    }
                  });
                }


              }, pView!, isBigScreen, searchController),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Container(
                          width: 2000,
                          height:wid>900?120:200,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15),),
                          ),
                          child: Flex(
                            direction: wid>900?Axis.horizontal:Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: wid>900?420:wid,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Customer"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customDropDownMenu(
                                            wid>900
                                                ? 200
                                                : (isBigScreen?(wid/2)-100:wid/2),
                                            40,
                                            customers,
                                            selectedCustomer?.name, (val) {
                                          setState(() {
                                            selectedCustomer =customers?.firstWhere((e) => e.name==val);
                                            //val;
                                          });
                                        }, context),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Required Date"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: wid>900 ? 200 :(wid/2)-100,
                                          height: 40,
                                          child: datePicker(context, reqDate, (picked) {
                                            setState(() {
                                              reqDate=picked!;
                                            });
                                          }),
                                        )
                                        // customDropDownMenu(
                                        //     wid>900
                                        //         ? 200
                                        //         : (wid/2)-100,
                                        //     40,
                                        //     customerList,
                                        //     selectedCustomer?.name, (val) {
                                        //   setState(() {
                                        //     selectedCustomer =customerList?.firstWhere((e) => e.name==val);
                                        //     //val;
                                        //   });
                                        // }, context),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                                height: 10,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Note"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    cTextfield(wid, 40,
                                            (val) {}, _noteController, "", TextDirection.rtl),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Expanded(
                          child: Container(
                            width: 2000,
                            color: Colors.grey.shade300,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  wid<=1000?SingleChildScrollView(
                                    controller: scrollController,
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 0.0),
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                                          Container(
                                              width: 100,
                                              // color: Colors.blue,
                                              child: Text("Reason")),
                                          GestureDetector(
                                            onTap: () {
                                              print("delete");
                                              setState(() {
                                                orderDetails.clear();
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
                                    ),
                                  ):Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
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
                                            child: Text("UOM")),
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
                                        Container(
                                            width: 100,
                                            // color: Colors.blue,
                                            child: Text("Reason")),
                                        GestureDetector(
                                          onTap: () {
                                            print("delete");
                                            setState(() {
                                              orderDetails.clear();
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
                                  Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                    margin: EdgeInsets.only(top: 10),
                                  ),
                                  returnedSelectedItemsScreen(orderDetails, isBigScreen,
                                      scrollController2, (val, index) {
                                        setState(() {
                                          if (double.parse(val) <=
                                              orderDetails[index].available) {
                                            orderDetails[index].quantity =
                                                double.parse(val);
                                            orderDetails[index].subtotal = double.parse(
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
                                                    Navigator.of(context, rootNavigator: true).pop();
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
                                      }, ["نەفرۆشراوە", "لە کۆگا بەسەرچووە", "هۆکاری تر",], reason, (val, index){
                                        setState(() {
                                          orderDetails[index].reason=val;
                                          print("${orderDetails[index].reason} $index");
                                        });
                                        print(val);
                                      }),
                                  Container(
                                    height: wid>900 ? 60 : 80,
                                    width: wid,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade300,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Flex(
                                      direction: wid>900
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
                                                "${orderDetails.length != 0 ? orderDetails.map((item) => item.subtotal).reduce((a, b) => a + b) : 0} IQD",
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
                        )
                      ],
                    ),
                  ),
                  isBigScreen?Positioned(
                    right: 0,
                    bottom: (hei/2)-40,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showM=!showM;
                            _key.currentState?.toggle();
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(5, 5),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0, -5),
                                blurRadius: 0,
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: FaIcon(showM?FontAwesomeIcons.xmark:FontAwesomeIcons.grip),
                          ),
                        ),
                      ),
                    ),
                  ):Container(),
                ],
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

              var item=orderDetails.firstWhereOrNull(((x) => x.productId==pView?[index].id));
              var ele=orderDetails.contains(item);

              if(ele){
                setState(() {
                  item?.quantity++;
                  item?.price += pView![index].price;
                });
              }else{
                setState(() {
                  var product = pView![index];
                  orderDetail = ReturnDetailsSView(
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
                    "",
                    1,
                    1,
                  );
                  orderDetails.add(orderDetail);
                  for(var a in orderDetails){
                    print(a.productId);
                  }
                });
              }


            }, pView!, isBigScreen, searchController), _controller),
            AnimatedOpacity(
              opacity: showValidationToast?1:0,
              duration: Duration(milliseconds: showValidationToast?0:500),
              child: validationErrorMessage(vEMessage),
            ),
            (customerList.isEmpty && pView.isEmpty)?Center(
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
      );
    });
  }
}
