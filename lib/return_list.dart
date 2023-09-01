import 'package:bn_sl/models/return_pagnation_response.dart';
import 'package:bn_sl/models/return_response.dart';
import 'package:bn_sl/providers/get_token.dart';
import 'package:bn_sl/services/login/auth.dart';
import 'package:bn_sl/services/order_service/order.dart';
import 'package:bn_sl/services/return/return.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';

import 'models/order_details_response.dart';
import 'models/order_pagnation_response.dart';
import 'models/pagnation_parameter.dart';

class ReturnList extends StatefulWidget {
  const ReturnList({super.key});

  @override
  State<ReturnList> createState() => _ReturnListState();
}
List pageController=[
  FontAwesomeIcons.anglesLeft,
  FontAwesomeIcons.angleLeft,
  FontAwesomeIcons.angleRight,
  FontAwesomeIcons.angleRight,
  FontAwesomeIcons.anglesRight,
];
late int itemId=0;
String searchQuery="";
DateTime fromSelectedDate = DateTime.now();
DateTime toSelectedDate = DateTime.now();
String _tokenKey='accessToken';
ReturnPagnationResponse? orderPagnation;
List<OrderDetailsResponse>? orderById=[];
List<ReturnResponse>? customerList;
String selectedListSize="10";                                                   // f6433e83-ab13-45a2-8277-2ba2f2f3b819
PagnationParameter pagnationParameter= PagnationParameter(1, 10, "Id", "Desc", [], "", 0, "", "${fromSelectedDate.toString().replaceAll(" ", "T")}", "${toSelectedDate.toString().replaceAll(" ", "T")}", false, true);

// PagnationParameter pagnationParameter1= PagnationParameter(1, 10, "Id", "Desc", [], "", 1, Provider.of<GetToken>(context, listen: false).dToken["id"], "${fromSelectedDate.toString().replaceAll(" ", "T")}", "${toSelectedDate.toString().replaceAll(" ", "T")}", false, true);
class _ReturnListState extends State<ReturnList> {
  // PagnationParameter pagnationParameter1= PagnationParameter(1, 10, "Id", "Desc", [], "", 1, Provider.of<GetToken>(ReturnList().context, listen: false).dToken["id"], "${fromSelectedDate.toString().replaceAll(" ", "T")}", "${toSelectedDate.toString().replaceAll(" ", "T")}", false, true);
  product() {
    (() async {
      ReturnHeadeClass pagnation = new ReturnHeadeClass();
      print(fromSelectedDate.toString().replaceAll(" ", "T"));
      orderPagnation = await pagnation.ReturnPagnation(pagnationParameter);
      //orderPagnation=a;
      // print(orderPagnation?.items!.last.customerText);
      if (orderPagnation != null) {
        setState(() {
          orderPagnation;
        });
      } else {
        print("Is Null.");
      }
    })();
  }

  customers() {
    (() async {
      print("-------------------");
      ReturnHeadeClass customer = new ReturnHeadeClass();
      customerList = await customer.ReturnById(itemId);
      setState(() {
        //
      });
      // print(customerList?[0].reason);
      print("---------------------");
    })();
  }
  String orderId="1374";
  // getProductById() {
  //   (() async {
  //     OrderDetails order = new OrderDetails();
  //     orderById = await order.GetOrderById(orderId);
  //     print("${orderById?[0].productText}))))))))");
  //     setState(() {
  //       orderById;
  //     });
  //   })();
  //   return orderById;
  // }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> decodedToken={};
  dynamic jwtToken;
  Future<dynamic> getDecodedToken(){
    jwtToken= Auth().ReadToken();
    print(jwtToken);
    return jwtToken;
  }
  // dynamic listOfCustomers;
  // Future<String> getListOfCustomers() async{
  //   Customer customer= Customer();
  //   listOfCustomers=  await customer.getCustomer();
  //   return listOfCustomers;
  // }
  dynamic returnedToken;
  late String returnedCustomers;
  late ScrollController scrollController;
  late ScrollController scrollController2;
  _scrollListener() {
    setState(() {
      scrollController2.jumpTo(
        scrollController.offset,
      );
    });
  }
  late ScrollController scrollController3;
  late ScrollController scrollController4;
  _scrollListener2() {
    setState(() {
      scrollController4.jumpTo(
        scrollController3.offset,
      );
    });
  }
  void initState() {
    super.initState();
    product();
    // customers();
    // getProductById();
    scrollController = ScrollController(initialScrollOffset: 0);
    scrollController2 = ScrollController(initialScrollOffset: 0);
    scrollController.addListener(() {
      _scrollListener();
    });
    scrollController3 = ScrollController(initialScrollOffset: 0);
    scrollController4 = ScrollController(initialScrollOffset: 0);
    scrollController3.addListener(() {
      _scrollListener2();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GetToken>(context, listen: false).readToken();
    });
    // (() async{
    //   returnedToken = await getDecodedToken();
    //   // returnedCustomers= await getListOfCustomers();
    //   print("---------------------------");
    //   print(returnedToken);
    //   print("---------------------------");
    //   print("???????????????????????????????????");
    //   // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImM4M2Q3NDFjLTkyMTEtNDAwZi1hNmQyLTQ4NjU4MzZmNTFmZSIsIndhcmVob3VzZWlkIjoiMSIsImlzcmVwcmVzZW50YXRpdmUiOiJGYWxzZSIsImZ1bGxuYW1lIjoiaGltZGFkIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZW1haWxhZGRyZXNzIjoiaGltZGFkQHR3YW4uY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6ImhpbWRhZCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJTdG9jayIsIkRhc2hib2FyZCIsIk1hbmFnZXIiLCJSZXBvcnQiXSwibmJmIjoxNjg5MTUzOTAyLCJleHAiOjE2OTAzNjM1MDIsImlzcyI6Imh0dHA6Ly9iYXJlemF6YWQtMDAxLXNpdGUxLmN0ZW1wdXJsLmNvbS8iLCJhdWQiOiJodHRwOi8vYmFyZXphemFkLTAwMS1zaXRlMS5jdGVtcHVybC5jb20ifQ.l2MozDxev0ig5nRnWV-AQjgxqzA01chua1lRMtjV_uA";
    //   decodedToken = Jwt.parseJwt("$returnedToken");
    //   print(decodedToken);
    //   print("+++++++++++++++++++++++++");
    //   // print(returnedCustomers);
    //   print("+++++++++++++++++++++++++");
    //   print(orderPagnation?.totalItems);
    //   print("+++++++++++++++++++++++++");
    // })();
    () async {
      // await Future.delayed(Duration.zero);
    pagnationParameter.warehouseId= await Provider.of<GetToken>(context, listen: false).dToken["warehouseid"];
    pagnationParameter.representativeId= await Provider.of<GetToken>(context, listen: false).dToken["id"];
    }();
  }
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = wid <= widthResponsiveness
        ? MediaQuery.of(context).size.height - 60
        : MediaQuery.of(context).size.height;

    bool isBigScreen = wid <= widthResponsiveness ? false : true;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.grey.shade300,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15),),
              ),
              child: Column(
                children: [
                  headOfOrder(wid, context, fromSelectedDate, toSelectedDate, (picked){
                    setState(() {
                      if(toSelectedDate.isAfter(fromSelectedDate)){
                        fromSelectedDate=picked!;
                        pagnationParameter.filterByDate=true;
                        pagnationParameter.frome=fromSelectedDate.toString().replaceAll(" ", "T");
                        pagnationParameter.to=toSelectedDate.toString().replaceAll(" ", "T");
                        product();
                      }else{
                        print("toSelectedDate.isNotAfter(fromSelectedDate)");
                      }
                    });
                  },
                          (picked){
                        setState(() {
                          if(toSelectedDate.isAfter(fromSelectedDate)){
                            toSelectedDate=picked!;
                            pagnationParameter.filterByDate=true;
                            pagnationParameter.frome=fromSelectedDate.toString().replaceAll(" ", "T");
                            pagnationParameter.to=toSelectedDate.toString().replaceAll(" ", "T");
                            product();
                          }else{
                            print("toSelectedDate.isNotAfter(fromSelectedDate)");
                          }
                        });
                      },
                      isBigScreen, (value){
                        if(value.toString().length%3==0 || value.toString().length==0){
                          searchQuery=value;
                          setState(() {
                            pagnationParameter.search=value;
                            product();
                          });
                        }else{
                          print("Not Yet!");
                        }
                      }
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    color: btnColor.withOpacity(0.2),
                    width: wid,
                    child: Center(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Tooltip(
                              message: "Order By ID",
                              child: GestureDetector(
                                onTap:(){
                                  setState(() {
                                    pagnationParameter.sortField="Id";
                                    pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                    // filterBy="Id";
                                    // filterByDate=false;
                                    product();
                                  });
                                },
                                child: Container(
                                    width: 100,
                                    // color: Colors.blue,
                                    child: Text("ID", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            Tooltip(
                              message: "Order By Customer",
                              child: GestureDetector(
                                onTap:(){
                                  setState(() {
                                    pagnationParameter.sortField="customer";
                                    pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                    // filterBy="orderNumber";
                                    // filterByDate=false;
                                    product();
                                  });
                                },
                                child: Container(
                                    width: 100,
                                    // color: Colors.blue,
                                    child: Text("Customer", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            Tooltip(
                              message: "Order By Status",
                              child: GestureDetector(
                                onTap:(){
                                  setState(() {
                                    pagnationParameter.sortField="status";
                                    pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                    // filterBy="date";
                                    // filterByDate=true;
                                    product();
                                  });
                                },
                                child: Container(
                                    width: 100,
                                    // color: Colors.blue,
                                    child: Text("Status", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            Tooltip(
                              message: "Order By Note",
                              child: GestureDetector(
                                onTap:(){
                                  setState(() {
                                    pagnationParameter.sortField="note";
                                    pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                    // filterBy="date";
                                    // filterByDate=true;
                                    product();
                                  });
                                },
                                child: Container(
                                    width: 100,
                                    // color: Colors.blue,
                                    child: Text("Note", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            Tooltip(
                              message: "Order by Added By",
                              child: GestureDetector(
                                onTap:(){
                                  setState(() {
                                    pagnationParameter.sortField="addedBy";
                                    pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                    // filterBy="date";
                                    // filterByDate=true;
                                    product();
                                  });
                                },
                                child: Container(
                                    width: 100,
                                    // color: Colors.blue,
                                    child: Text("Added By", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            Tooltip(
                              message: "Order by date",
                              child: GestureDetector(
                                onTap:(){
                                  setState(() {
                                    pagnationParameter.sortField="date";
                                    pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                    // filterBy="date";
                                    // filterByDate=true;
                                    product();
                                  });
                                },
                                child: Container(
                                    width: 100,
                                    // color: Colors.blue,
                                    child: Text("date", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                //filterBy="";
                              },
                              child: Container(
                                  width: 100,
                                  // color: Colors.blue,
                                  child: Text("Actions", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: wid,
                      // padding: EdgeInsets.symmetric(vertical: 20),
                      // color: Colors.red,
                      child: RefreshIndicator(
                        color: btnColorHover,
                        onRefresh: (){
                          return Future.delayed(
                            Duration(seconds: 1),
                                () {
                              setState(() {
                                pagnationParameter.search="";
                                product();
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
                        child: ListView.builder(
                            itemCount: orderPagnation?.items?.length,//int.parse(selectedListSize),
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () {
                                  (() async {
                                    ReturnHeadeClass order =
                                    new ReturnHeadeClass();
                                    customerList = await order.ReturnById(orderPagnation!.items![index].id);
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext
                                          contex) {
                                            return returnInfoAlertDialog(
                                                hei - 200,
                                                hei - 200,
                                                isBigScreen,
                                                "Close",
                                                context, () {
                                              Navigator.of(
                                                  context,
                                                  rootNavigator:
                                                  true)
                                                  .pop();
                                            }, orderPagnation!.items![index],
                                                customerList,
                                                scrollController3,
                                                scrollController4);
                                          });
                                    });
                                  })();
                                  print("${orderId}");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid),
                                        bottom: BorderSide(color: index==int.parse(selectedListSize)-1?Colors.grey.shade300:Colors.transparent, width: 1, style: BorderStyle.solid)
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      10.0, 15.0, 10.0, 15.0),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      controller: scrollController2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 100,
                                              // color: Colors.blue,
                                              child: orderPagnation!=null?Text("${orderPagnation?.items?[index].id}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),)),
                                          Container(
                                              width: 100,
                                              // color: Colors.blue,
                                              child: orderPagnation!=null?Text("${orderPagnation?.items?[index].customerText}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),)),
                                          Container(
                                            width: 100,
                                            padding: EdgeInsets
                                                .only(
                                                right:
                                                30),
                                            // color: Colors.blue,
                                            child: orderPagnation!=null?Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: orderPagnation?.items?[index].status==1?Colors
                                                      .blue
                                                      .shade50:Colors.amber.shade50,
                                                  borderRadius:
                                                  BorderRadius
                                                      .all(
                                                    Radius.circular(
                                                        5),
                                                  ),
                                                ),
                                                child: Center(child: Text("${orderPagnation?.items?[index].status==1?"Approved":"Pending"}", style: TextStyle(fontSize: 10, color: orderPagnation?.items?[index].status==1?Colors.blue:Colors.amber),))):Container(height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),),),
                                          Container(
                                            width: 100,
                                            height: 20,
                                            // color: Colors.blue,
                                            child: orderPagnation!=null?Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(child: Text(overflow: TextOverflow.ellipsis,"${orderPagnation?.items?[index].note}eeeeeeeeeeeee", style: TextStyle(fontSize: 10, color: Colors.black54),)),
                                              ],
                                            ):Center(child: Container(margin: EdgeInsets.only(right: 40, top: 5, bottom: 5), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),)),),
                                          Container(
                                            width: 100,
                                            // color: Colors.blue,
                                            child: orderPagnation!=null?Text("${orderPagnation?.items?[index].addedBy.split("T")[0]}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),),),
                                          Container(
                                            width: 100,
                                            // color: Colors.blue,
                                            child: orderPagnation!=null?Text("${orderPagnation?.items?[index].date.split("T")[0]}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),),),
                                          Container(
                                            width: 100,
                                            padding: EdgeInsets.only(right: 70),
                                            // color: Colors.blue,
                                            child: GestureDetector(
                                              onTap: () {
                                                print("print $index");
                                                setState(() {
                                                  // orderDetails.clear();
                                                  // odID.clear();
                                                });
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                  BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Center(child: FaIcon(FontAwesomeIcons.print, size: 15,)),
                                              ),
                                            ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    direction: isBigScreen?Axis.horizontal:Axis.vertical,
                    children: [
                      Row(
                        children: [
                          // customDropDownMenu(200, 40, ["10", "25", "50", "100"], selectedListSize, (val) {
                          //   setState(() {
                          //     selectedListSize=val;
                          //   });
                          // }, context),
                          Container(
                            width: 100,
                            height: 40,
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
                                isExpanded: true,
                                disabledHint: Text("Select a Customer"),
                                hint: Text("Select a Customer"),
                                value: selectedListSize!=null?selectedListSize:null,
                                style: TextStyle(color: Colors.black),
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 30,
                                  color: Colors.black54,
                                ),
                                items: List<String>.from(["10", "25", "50", "100"]).map((String itemss) {
                                  return DropdownMenuItem(
                                    value: itemss,
                                    child: Center(child: Text(itemss, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedListSize=val!;
                                    pagnationParameter?.pageSize=int.parse(selectedListSize);
                                    pagnationParameter.pageNumber=1;
                                    product();
                                  });
                                  print(selectedListSize);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Total: ${orderPagnation!=null?orderPagnation?.totalItems:"0"}"),
                        ],
                      ),
                      SizedBox(width: 20, height: 20,),
                      Row(
                        children: List.generate(5, (index) {
                          return Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: orderPagnation!=null?orderPagnation!.hasNextPage && orderPagnation!.hasPreviousPage?true:(orderPagnation!.hasNextPage && index>=2)?true:(orderPagnation!.hasPreviousPage && index<=2)?true:false:false,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  switch(index){
                                    case 0: print("FB"); setState(() {
                                      pagnationParameter.pageNumber=1;//!=1?(pagnationParameter.pageNumber>2?pagnationParameter.pageNumber=pagnationParameter.pageNumber-2:pagnationParameter.pageNumber=pagnationParameter.pageNumber-1):(pagnationParameter.pageNumber=1);
                                      ///print("${pageNumber})))))))))))");
                                    }); break;
                                    case 1: print("B");
                                    pagnationParameter.pageNumber!=1?(pagnationParameter.pageNumber=pagnationParameter.pageNumber-1):(pagnationParameter.pageNumber=1);
                                    //print("${pageNumber})))))))))))");
                                    break;
                                    case 2: print("C"); break;
                                    case 3: print("F");
                                    pagnationParameter.pageNumber!=orderPagnation!.totalPages?(pagnationParameter.pageNumber=pagnationParameter.pageNumber+1):(pagnationParameter.pageNumber=orderPagnation!.totalPages);
                                    // print("${pageNumber})))))))))))");
                                    break;
                                    case 4: print("FF");
                                    pagnationParameter.pageNumber=orderPagnation!.totalPages;//!=orderPagnation!.totalPages?(pagnationParameter.pageNumber==orderPagnation!.totalPages-1?pagnationParameter.pageNumber=pagnationParameter.pageNumber+1:pagnationParameter.pageNumber=pagnationParameter.pageNumber+2):(pagnationParameter.pageNumber=orderPagnation!.totalPages);
                                    //print("${pageNumber})))))))))))${orderPagnation!.totalPages}");
                                    break;
                                    default: print("FB"); break;
                                  }
                                  product();
                                });

                              },
                              child: Container(
                                height:40,
                                width: index==2?60:40,
                                margin: index==2?EdgeInsets.only(left: 10, right: 15):EdgeInsets.only(right: 5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: index==2?btnColor:Color(0xfff8f8f8),
                                ),
                                child: Center(
                                  child: index==2?Text("${orderPagnation?.pageIndex}", style: TextStyle(color: Colors.white),)
                                      :FaIcon(pageController[index], size: 10, color: Colors.black/*npColor[index]==Colors.white?Colors.white:Colors.black,*/),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            orderPagnation==null?Center(
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
    );
  }
}
