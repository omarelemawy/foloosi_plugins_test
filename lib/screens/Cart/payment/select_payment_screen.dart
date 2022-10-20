import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../constants/color_constans.dart';
import '../../../constants/themes.dart';
import '../../../constants/utils.dart';
import '../../../localization/localization_constants.dart';
import '../../../models/address_model.dart';
import '../../../models/order_data_model.dart';
import '../../../models/user_data.dart';
import '../../home/home_screen.dart';
import 'foloosi_screen.dart';

class SelectPaymentScreen extends StatefulWidget {
   SelectPaymentScreen({Key? key,this.orderData,this.addressId}) : super(key: key);
  OrderData? orderData;
  int? addressId;
   bool isLoading=false;
  @override
  _SelectPaymentScreenState createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    void getExploreItem
        (lang,orderId,userId,paymentMethod,addressId,email)
    async{
      widget.isLoading= true;
      setState(() {
        widget.isLoading= true;
      });
      print(orderId);
      print(userId);
      print(addressId);
      print(paymentMethod);
      var response = await Dio().post(
          Utils.CreateOrders_URL,options:
      Options(
          headers:{
        "lang":lang,
        "Accept-Language":lang,
        "user":userId
      }),data: {
            "order_id":orderId,
            "payment_method":paymentMethod,
            "address_id":addressId,
          }
      );
      print(response.data);
      if(response.data["status"]=="success")
      {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return donDialog(context,email);
            });

      }
      else{
        print("failed");
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 1,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon:
        Icon(Icons.arrow_back_ios, size: 14, color: HexColor("#9098B1"),)),
        title: customText(
            getTranslated(context, "Payment Method",)!
            , fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: widget.isLoading?
      const Center(
          child:SpinKitChasingDots(
            color: customColor,
            size: 40,
          )):Column(
        children: [
          ListTile(
              title: customText("foloosi",
                  color: customTextColor, fontWeight: FontWeight.w600),
              leading: Icon(
                Icons.credit_card,
                color: HexColor("#40BFFF"),
              ),
              onTap: () {
                getUserDate().then((value) async {
                  widget.orderData = OrderData(
                      orderId: widget.orderData!.orderId,
                      orderAmount: widget.orderData!.orderAmount,
                      orderDescription: widget.orderData!.orderDescription,
                      currencyCode: "AED",
                      country: widget.orderData!.country,
                      state: widget.orderData!.state,
                      address: Address(
                        city: widget.orderData!.address!.city,
                        country: widget.orderData!.address!.country,
                        postalCode: widget.orderData!.address!.postalCode,

                      ),
                      customer: Customer(
                          name: value.name,
                          email: value.email,
                          mobile: value.phone,
                          city: widget.orderData!.state,
                          address: widget.orderData!.address!.address,
                          code: value.countryCode
                      )
                  );
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) =>
                      FoloosiScreen(
                        orderData:
                        widget.orderData,
                        addressId: widget.addressId,
                        userId: value.id,
                      )
                  ));
                });
              }
          ),

          ListTile(
              title: customText("Cash",
                  color: customTextColor, fontWeight: FontWeight.w600),
              leading: Icon(
                Icons.money,
                color: HexColor("#40BFFF"),
              ),
              onTap: () {
                getUserDate().then((value) async {
                  getExploreItem(Localizations
                      .localeOf(context)
                      .languageCode
                      , widget.orderData!.orderId,
                      value.id,
                      "cash",
                      widget.addressId,
                     value.email);
                });
              }
          ),
        ],
      ),
    );
  }
}
Widget donDialog(context,email)
{
  return AlertDialog(
    actions: [
      SizedBox(height: 60,),
      Center(
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height/2.3,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            customText(
                getTranslated(context, "Your request has been sent successfully")!,
                color: customTextColor.withOpacity(.3),
                fontWeight: FontWeight.bold,
                size: 25),
            const SizedBox(
              height: 100,
            ),
            Material(
              elevation: 5,
              child: Container(
                width:
                MediaQuery.of(context).size.width/1.5,
                height: 40,
                decoration: BoxDecoration(
                    color: HexColor("#087DA9"),
                    border: Border.all(
                        color: customTextColor
                            .withOpacity(.2)),
                    borderRadius:
                    BorderRadius.circular(4)),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context)=>HomeScreen(
                        Localizations.localeOf(context).languageCode
                        ,0,
                          email: email,
                        )
                        ), (route) => false);
                  },
                  child: customText(
                      getTranslated(context, "Done")!,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    ],
  );
}
