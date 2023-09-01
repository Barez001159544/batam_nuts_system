import 'package:bn_sl/maps.dart';
import 'package:bn_sl/models/customer_response.dart';
import 'package:bn_sl/models/return_pagnation_response.dart';
import 'package:bn_sl/new_oreder.dart';
import 'package:bn_sl/providers/customer_controller.dart';
import 'package:bn_sl/providers/get_token.dart';
import 'package:bn_sl/providers/product_controller.dart';
import 'package:bn_sl/services/customer_service/customer.dart';
import 'package:bn_sl/services/login/auth.dart';
import 'package:bn_sl/services/order_service/order.dart';
import 'package:bn_sl/services/return/return.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/customer_pagnation_response.dart';
import 'models/order_details_response.dart';
import 'models/order_pagnation_response.dart';
import 'models/pagnation_parameter.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}
CustomerResponse? customerNM;
DateTime reqDate= DateTime.now();
List pageController=[
  FontAwesomeIcons.anglesLeft,
  FontAwesomeIcons.angleLeft,
  FontAwesomeIcons.angleRight,
  FontAwesomeIcons.angleRight,
  FontAwesomeIcons.anglesRight,
];
bool isRed=false;
String searchQuery="";
String selectedListSize="10";
int customerId=0;
String nmCustomer="New Customer";

TextEditingController name= TextEditingController();
TextEditingController employee= TextEditingController();
TextEditingController phoneNumber= TextEditingController();
TextEditingController address= TextEditingController();
CustomerPagnationResponse? orderPagnation;
PagnationParameter pagnationParameter= PagnationParameter(1, 10, "Id", "Desc", [""], "$searchQuery", 0, "", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", false, true);

class _CustomersState extends State<Customers> {
  late Position position;
  void locationHereIs() async {
    await locationServicesStatus();
    await checkLocationPermissions();
  }

  Future<void> checkLocationPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();
    print('Current Location Permission Status = $permission.');
  }

  void checkLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> locationServicesStatus() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print(
        'Currently, the emulator\'s Location Services Status = $isLocationServiceEnabled.');
  }
  product() {
    (() async {
      Customer pagnation = new Customer();
      orderPagnation = await pagnation.GetPagination(pagnationParameter);
      //orderPagnation=a;
      print(orderPagnation?.items?.last.phoneNumber);
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
      Customer customer = new Customer();
      customerNM = await customer.Post(CustomerResponse(customerId, "${name.text}", "${employee.text}", "${phoneNumber.text}", "${address.text}", "${Provider.of<GetToken>(context).dToken["fullname"]}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", true));
      setState(() {
        //
      });
      print("${customerNM}---------------------------------------");
      print("---------------------");
    })();
  }
  updateCustomers() {
    (() async {
      print("-------------------");
      Customer customer = new Customer();
      customerNM = await customer.Put(CustomerResponse(customerId, "${name.text}", "${employee.text}", "${phoneNumber.text}", "${address.text}", "${Provider.of<GetToken>(context, listen: false).dToken["fullname"]}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", true));
      setState(() {
        //
      });
      print("${customerNM}---------------------------------------");
      print("---------------------");
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
  late ScrollController scrollController3;
  late ScrollController scrollController4;
  _scrollListener2() {
    setState(() {
      scrollController4.jumpTo(
        scrollController3.offset,
      );
    });
  }
  Map<String, dynamic> decodedToken={};
  dynamic jwtToken;
  Future<dynamic> getDecodedToken(){
    jwtToken= Auth().ReadToken();
    print(jwtToken);
    return jwtToken;
  }
  dynamic returnedToken;
  void initState() {
    super.initState();
    product();
    locationHereIs();
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
      Provider.of<CustomerController>(context, listen: false).getCustomerPagination(pagnationParameter);
    });
    () async {
      // await Future.delayed(Duration.zero);
      pagnationParameter.warehouseId= await Provider.of<GetToken>(context, listen: false).dToken["warehouseid"];
      pagnationParameter.representativeId= await Provider.of<GetToken>(context, listen: false).dToken["id"];
    }();
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
    // })();
  }
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = wid <= widthResponsiveness
        ? MediaQuery.of(context).size.height - 60
        : MediaQuery.of(context).size.height;

    bool isBigScreen = wid <= widthResponsiveness ? false : true;
    return Consumer<CustomerController>(
      builder: (context, customerController, child) {
        return Expanded(
          child: GestureDetector(
              onHorizontalDragEnd: (DragEndDetails drag) {
                if(drag.primaryVelocity == null) return;
                if(drag.primaryVelocity! < 0) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return CustomersLocation();
                          }));
                }else{
                  print(drag.primaryVelocity);
                }
              },
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

                        // orderPagnation==null?SizedBox(height: 10,):Container(),
                        Row(
                          mainAxisAlignment: wid>600?MainAxisAlignment.end:MainAxisAlignment.spaceBetween,
                          children: [
                            searchTextField(wid>900?wid*0.2:(wid>600?wid*0.4:wid*0.5), 40, (value) { }, (value) {
                              // setState(() {
                              //   // pagnationParameter.search=value;
                              //   // product();
                              // });
                              if(value.length%3==0){
                                setState(() {
                                  pagnationParameter.search=value;
                                  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                  //   Provider.of<GetToken>(context, listen: false).readToken();
                                  customerController.getCustomerPagination(pagnationParameter);
                                  // });
                                });
                              }
                            }, TextEditingController()),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                print("OK");
                                name.text="";
                                employee.text="";
                                phoneNumber.text="";
                                address.text="";
                                customerId=0;
                                nmCustomer="New Customer";
                                setState((){
                                  isRed=false;
                                });
                                showDialog(
                                context: context,
                                builder: (BuildContext contex)
                                {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return customerAlertDialog(FaIcon(FontAwesomeIcons.f), "New Customer", "", "Cancel", "Submit", context, () {
                                        print("Submited: ${name.text} ${employee.text} ${phoneNumber.text} ${address.text}");
                                        if(name.text=="" || employee.text=="" || phoneNumber.text=="" || address.text==""){
                                          setState(() {
                                            isRed=true;
                                            print(isRed);
                                          });
                                        }else{
                                          customerController.updateCustomer(CustomerResponse(customerId, "${name.text}", "${employee.text}", "${phoneNumber.text}", "${address.text}", "${Provider.of<GetToken>(context, listen: false).dToken["fullname"]}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", true));
                                          Navigator.of(context, rootNavigator: true).pop();
                                          List<String>? l;
                                          (() async {
                                            String key='${name.text}';
                                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                                            Set<String> keys= prefs.getKeys();
                                            saveLatLong(String lat, String long) async {
                                              await prefs.setStringList(key, <String>[lat, long]);
                                            }
                                            saveLatLong("${position.latitude}", "${position.longitude}");
                                            print("${position.latitude}, ${position.longitude}");
                                            Future<List<String>?> readLatLong() async {
                                              print(prefs.getKeys());
                                              for(int i=0; i<keys.length; i++){
                                                print(prefs.getStringList("${keys.elementAt(i)}"));
                                              }
                                              final List<String>? items = prefs.getStringList(key);
                                              return items;
                                            }
                                            l= await readLatLong();
                                            print(l);
                                          })();
                                          name.text="";
                                          employee.text="";
                                          phoneNumber.text="";
                                          address.text="";
                                          setState((){
                                            isRed=false;
                                          });}
                                      }, () {
                                        print("Cancel");
                                        name.text="";
                                        employee.text="";
                                        phoneNumber.text="";
                                        address.text="";
                                        setState((){
                                          isRed=false;
                                        });
                                        Navigator.of(context, rootNavigator: true).pop();
                                      }, name, employee, phoneNumber, address, isRed, (){
                                        (() async {
                                          Position position1 = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                          position= position1;
                                          print(position1.longitude);
                                        })();
                                      });
                                    }
                                  );
                                }
                                );
                                setState(() {
                                  //
                                });
                                },
                              child: Container(
                                width: wid>900?wid*0.05:(wid>600?wid*0.1:wid*0.2),
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: btnColor,
                                ),
                                child: Center(
                                  child: FaIcon(FontAwesomeIcons.userPlus, color: Colors.white, size: 15, semanticLabel: "Add Customer",),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
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
                                          // // filterBy="Id";
                                          // // filterByDate=false;
                                          customerController.getCustomerPagination(pagnationParameter);
                                        });
                                      },
                                      child: Container(
                                          width: 100,
                                          // color: Colors.blue,
                                          child: Text("ID", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Order By Name",
                                    child: GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          pagnationParameter.sortField="name";
                                          pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                          // // filterBy="orderNumber";
                                          // // filterByDate=false;
                                          customerController.getCustomerPagination(pagnationParameter);
                                        });
                                      },
                                      child: Container(
                                          width: 100,
                                          // color: Colors.blue,
                                          child: Text("Name", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Order by Employee",
                                    child: GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          pagnationParameter.sortField="Employee";
                                          pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                          // // filterBy="orderNumber";
                                          // // filterByDate=false;
                                          customerController.getCustomerPagination(pagnationParameter);
                                        });
                                      },
                                      child: Container(
                                          width: 100,
                                          // color: Colors.blue,
                                          child: Text("Employee", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Order By Phone No.",
                                    child: GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          pagnationParameter.sortField="phoneNumber";
                                          pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                          // // filterBy="date";
                                          // // filterByDate=true;
                                          customerController.getCustomerPagination(pagnationParameter);
                                        });
                                      },
                                      child: Container(
                                          width: 100,
                                          // color: Colors.blue,
                                          child: Text("Phone No.", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Order by Address",
                                    child: GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          pagnationParameter.sortField="address";
                                          pagnationParameter.sortOrder=pagnationParameter.sortOrder=="Desc"?"Asc":"Desc";
                                          // // filterBy="date";
                                          // // filterByDate=true;
                                          customerController.getCustomerPagination(pagnationParameter);
                                        });
                                      },
                                      child: Container(
                                          width: 100,
                                          // color: Colors.blue,
                                          child: Text("Address", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap:(){
                                  //     //filterBy="";
                                  //   },
                                  //   child: Container(
                                  //       width: 100,
                                  //       // color: Colors.blue,
                                  //       child: Text("Actions", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),)),
                                  // ),
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
                                      customerController.getCustomerPagination(pagnationParameter);
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
                                  itemCount: customerController.customerPaginationResponse?.items?.length,//int.parse(selectedListSize),
                                  itemBuilder: (context, index){
                                    return GestureDetector(
                                      onTap: (){
                                        name.text=customerController.customerPaginationResponse!.items![index].name;
                                        employee.text=customerController.customerPaginationResponse!.items![index].employee!;
                                        phoneNumber.text=customerController.customerPaginationResponse!.items![index].phoneNumber!;
                                        address.text=customerController.customerPaginationResponse!.items![index].address!;
                                        customerId=customerController.customerPaginationResponse!.items![index].id;
                                        String old=name.text;
                                        nmCustomer="Edit Customer";
                                        print("$customerId");
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext contex)
                                            {
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return customerAlertDialog(FaIcon(FontAwesomeIcons.f), "$nmCustomer", "", "Cancel", "Submit", context, () {
                                                      print("Submited: ${name.text} ${employee.text} ${phoneNumber.text} ${address.text}");
                                                      if(name.text=="" || employee.text=="" || phoneNumber.text=="" || address.text==""){
                                                        setState(() {
                                                          isRed=true;
                                                          print(isRed);
                                                        });
                                                      }else{
                                                        customerController.updateCustomer(CustomerResponse(customerId, "${name.text}", "${employee.text}", "${phoneNumber.text}", "${address.text}", "${Provider.of<GetToken>(context, listen: false).dToken["fullname"]}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", "${reqDate.toString().replaceAll(" ", "T")}", true));
                                                        Navigator.of(context, rootNavigator: true).pop();
                                                        List<String>? l;
                                                        (() async {
                                                          String key='${name.text}';
                                                          print("(((((((((((((((($key");
                                                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          Set<String> keys= prefs.getKeys();
                                                          saveLatLong(String lat, String long) async {
                                                            await prefs.setStringList(key, <String>[lat, long]);
                                                          }
                                                          saveLatLong("${position.latitude}", "${position.longitude}");
                                                          print("${position.latitude}, ${position.longitude}");
                                                          Future<List<String>?> readLatLong() async {
                                                            print(prefs.getKeys());
                                                            for(int i=0; i<keys.length; i++){
                                                              print(prefs.getStringList("${keys.elementAt(i)}"));
                                                            }
                                                            final List<String>? items = prefs.getStringList(key);
                                                            return items;
                                                          }
                                                          l= await readLatLong();
                                                          print(l);
                                                        })();
                                                        name.text="";
                                                        employee.text="";
                                                        phoneNumber.text="";
                                                        address.text="";
                                                        setState((){
                                                          isRed=false;
                                                        });
                                                      }
                                                    }, () {
                                                      print("Cancel");
                                                      name.text="";
                                                      employee.text="";
                                                      phoneNumber.text="";
                                                      address.text="";
                                                      setState((){
                                                        isRed=false;
                                                      });
                                                      Navigator.of(context, rootNavigator: true).pop();
                                                    }, name, employee, phoneNumber, address, isRed, (){
                                                      (() async {
                                                        Position position1 = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                                        position= position1;
                                                        print(position1.longitude);
                                                      })();
                                                    });
                                                  }
                                              );
                                            }
                                        );
                                        setState(() {
                                          //
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid),
                                              bottom: BorderSide(color: index==int.parse(selectedListSize)-1?Colors.grey.shade300:Colors.transparent, width: 1, style: BorderStyle.solid)
                                          ),
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 24.6, 10.0, 24.6),
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
                                                    child: customerController.customerPaginationResponse!=null?Text("${customerController.customerPaginationResponse?.items?[index].id}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),)),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: customerController.customerPaginationResponse!=null?Text("${customerController.customerPaginationResponse?.items?[index].name}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),)),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: customerController.customerPaginationResponse!=null?Text("${customerController.customerPaginationResponse?.items?[index].employee}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),)),
                                                Container(
                                                    width: 100,
                                                    // color: Colors.blue,
                                                    child: customerController.customerPaginationResponse!=null?Text("${customerController.customerPaginationResponse?.items?[index].phoneNumber}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),)),
                                                Container(
                                                  width: 100,
                                                  // color: Colors.blue,
                                                  child: customerController.customerPaginationResponse!=null?Text("${customerController.customerPaginationResponse?.items?[index].address}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),),),
                                                // Container(
                                                //   width: 100,
                                                //   // color: Colors.blue,
                                                //   child: orderPagnation!=null?Text("${orderPagnation?.items?[index].date.split("T")[0]}", style: TextStyle(fontSize: 10, color: Colors.black54),):Container(margin: EdgeInsets.only(right: 40), height: 10, decoration: BoxDecoration(color: Color(0xfff8f8f8), borderRadius: BorderRadius.all(Radius.circular(5))),),),
                                                // Container(
                                                //   width: 100,
                                                //   padding: EdgeInsets.only(right: 70),
                                                //   // color: Colors.blue,
                                                //   child: GestureDetector(
                                                //     onTap: () {
                                                //       print("print $index");
                                                //       setState(() {
                                                //         // orderDetails.clear();
                                                //         // odID.clear();
                                                //       });
                                                //     },
                                                //     child: Container(
                                                //       width: 30,
                                                //       height: 30,
                                                //       decoration: BoxDecoration(
                                                //         color: Colors.grey.shade300,
                                                //         borderRadius:
                                                //         BorderRadius.all(
                                                //           Radius.circular(5),
                                                //         ),
                                                //       ),
                                                //       child: Center(child: FaIcon(FontAwesomeIcons.print, size: 15,)),
                                                //     ),
                                                //   ),),
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
                                          customerController.getCustomerPagination(pagnationParameter);                                        });
                                        print(selectedListSize);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Total: ${customerController.customerPaginationResponse?.totalItems==null?"0":customerController.customerPaginationResponse?.totalItems}"),
                              ],
                            ),
                            SizedBox(width: 20, height: 20,),
                            Row(
                              children: List.generate(5, (index) {
                                return Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: customerController.customerPaginationResponse!=null?customerController.customerPaginationResponse!.hasNextPage && customerController.customerPaginationResponse!.hasPreviousPage?true:(customerController.customerPaginationResponse!.hasNextPage && index>=2)?true:(customerController.customerPaginationResponse!.hasPreviousPage && index<=2)?true:false:false,
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
                                          pagnationParameter.pageNumber!=customerController.customerPaginationResponse!.totalPages?(pagnationParameter.pageNumber=pagnationParameter.pageNumber+1):(pagnationParameter.pageNumber=customerController.customerPaginationResponse!.totalPages);
                                          // print("${pageNumber})))))))))))");
                                          break;
                                          case 4: print("FF");
                                          pagnationParameter.pageNumber=customerController.customerPaginationResponse!.totalPages;//!=orderPagnation!.totalPages?(pagnationParameter.pageNumber==orderPagnation!.totalPages-1?pagnationParameter.pageNumber=pagnationParameter.pageNumber+1:pagnationParameter.pageNumber=pagnationParameter.pageNumber+2):(pagnationParameter.pageNumber=orderPagnation!.totalPages);
                                          //print("${pageNumber})))))))))))${orderPagnation!.totalPages}");
                                          break;
                                          default: print("FB"); break;
                                        }
                                        customerController.getCustomerPagination(pagnationParameter);
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
                                        child: index==2?Text("${customerController.customerPaginationResponse?.pageIndex}", style: TextStyle(color: Colors.white),)
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
                  customerController.customerPaginationResponse==null?Center(
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
    );
  }
}
