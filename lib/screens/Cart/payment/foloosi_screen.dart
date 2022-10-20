import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

import 'package:foloosi_plugins/foloosi_plugins.dart';

import '../../../constants/color_constans.dart';
import '../../../constants/utils.dart';
import '../../../models/order_data_model.dart';
import '../../home/home_screen.dart';

class FoloosiScreen extends StatefulWidget {
   FoloosiScreen({Key? key,this.orderData,this.addressId,this.userId}) : super(key: key);
  OrderData? orderData;
  int? addressId;
  String? userId;
  bool isLoading=false;
  @override
  _FoloosiScreenState createState() => _FoloosiScreenState();
}

class _FoloosiScreenState extends State<FoloosiScreen> {
  TextEditingController orderIdTextField = TextEditingController();
  final key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void getExploreItem
      (lang,orderId,userId,paymentMethod,addressId,transactionId)
  async{
    widget.isLoading= true;
    print(orderId);
    print(userId);
    print(addressId);
    var response = await Dio().post(
        Utils.CreateOrders_URL,options:
    Options(headers: {
      "lang":lang,
      "Accept-Language":lang,
      "user":userId
    }),
        data: {
          "order_id":orderId,
          "payment_method":paymentMethod,
          "address_id":addressId,
          "transaction_id":transactionId,
        }
    );
    print(response.data);
    if(response.data["status"]=="success")
    {
      widget.isLoading= true;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=>HomeScreen(
           lang,0,
            email: widget.orderData!.customer!.email,
          )
          ), (route) => false);

    }else{
      print("failed");
    }
  }

  Future<void> initPlatformState() async {
    print(widget.orderData!.customer!.name);
    if( widget.orderData!.orderAmount!.trim().isNotEmpty){
      try {
        await
        FoloosiPlugins.init(
            "live_\$2y\$10\$1RDbg8uK5I4gcJUjuqnKoOEEB7x0YtKBnOzH6AArZgbIkw2COd7ka");
        var res = {
          "orderId": widget.orderData!.orderId,
          "orderDescription": widget.orderData!.orderDescription,
          "orderAmount": double.parse(widget.orderData!.orderAmount!),
          "state": widget.orderData!.state,
          "customColor": "",
          "country": "ARE",
          "currencyCode": "AED",
          "customerUniqueReference": "",
          //Customer Unique Reference value should be email/mobile no/uniqueCustomer id from your DB
          "customer": {
            "name": widget.orderData!.customer!.name,
            "email": widget.orderData!.customer!.email,
            "mobile": widget.orderData!.customer!.mobile,
            "code": widget.orderData!.customer!.mobile,
            "address": widget.orderData!.customer!.address,
            "city": widget.orderData!.address!.city,
          }
        };
        print(res);
        FoloosiPlugins.setLogVisible(true);
        var res1 = {
          "orderId": "ORDER001",
          "orderDescription": "Order Description",
          "orderAmount": double.parse(widget.orderData!.orderAmount!),
          "state": "Dubai",
          "postalCode": "12345",
          "customColor": "",
          "country": "ARE",
          "currencyCode": "AED",
          "customerUniqueReference": "",
          "customer": {
            "name": "John",
            "email": "john@email.com",
            "mobile": "501234567",
            "code": "971",
            "address": "123 Dubai",
            "city": "Dubai",
          },
        };


        var result = await FoloosiPlugins.makePayment(json.encode(res));
        if (kDebugMode) {
          print(result);
          if(result["success"]){
            getExploreItem(Localizations.localeOf(context).languageCode
                ,widget.orderData!.orderId,
                widget.userId,
                "foloosi",
                widget.addressId,
                result["transaction_id"]);


          }
        }
      } on Exception catch (exception) {
        exception.runtimeType;
      }
  }
    else {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) =>
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please enter amount"),
              ),
            ),
      );
    }
    // Platform messages may fail, so we use a try/catch PlatformException.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
    // _platformVersion = platformVersion;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Foloosi',style: TextStyle(
            color: customColor
          ),),
        ),
        body: widget.isLoading?
        const Center(
            child:   SpinKitChasingDots(
              color: customColor,
              size: 40,
            )):
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Amount Is",
                        style: TextStyle(
                          color: customColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text(
                          widget.orderData!.orderAmount!,
                        style: const TextStyle(
                            color: customColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  )
                ),
              ),
              InkWell(
                onTap: () {
                  initPlatformState();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: customColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  margin: const EdgeInsets.all(30),
                  height: 40,

                  child: const Center(
                    child: Text(
                      "Proceed Payment",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
