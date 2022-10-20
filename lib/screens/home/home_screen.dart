import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gnon/push_notification.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../constants/color_constans.dart';
import '../../constants/themes.dart';
import '../../localization/localization_constants.dart';
import '../Cart/cart_screen.dart';
import '../account/account_screen.dart';
import '../home_data/home_bloc/home_cubit.dart';
import '../home_data/home_bloc/home_state.dart';
import '../home_data/home_data_screen.dart';
import '../offer/offer_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.lang,this.initialIndex, {Key? key, this.email}) : super(key: key);
  String? email;
  String? lang;
  int? initialIndex;

  @override
  _HomeScreenState createState() => _HomeScreenState(this.initialIndex);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.initialIndex);
  int? initialIndex;
 late int? _totalNotification;



  PushNotification? _notificationInfo;

  void requestAndRegisterNotification() async{}

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = PersistentTabController(initialIndex:initialIndex!);
    return BlocProvider(
      create: (context) => HomeCubit()..getSettings(widget.lang)..
      SendRegisterToken(widget.lang),

      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var settingsModel = HomeCubit.get(context).settingsModel;
          List<Widget> _buildScreens() {
            print(widget.lang);
            return [
              HomeDataScreen(context, widget.lang!,settingsModel!.data!.contactData!.mobile!),
              CartScreen(context,widget.lang,settingsModel.data!.contactData!.mobile!),
              OfferScreen(context, widget.lang!,settingsModel.data!.contactData!.mobile!),
              AccountScreen(context, widget.email!, settingsModel.data!.contactData!.mobile!),
            ];
          }

          List<PersistentBottomNavBarItem> _navBarsItems() {
            return [
              PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.home),
                title: (getTranslated(context, "Home",)!
                ),
                activeColorPrimary: customColor,
                inactiveColorPrimary: HexColor("#9098B1"),
              ),

              PersistentBottomNavBarItem(
                icon: settingsModel!.data!.cartNumber==0?
                const Icon(Icons.shopping_cart_outlined):
                Badge(
                  toAnimate: true,
                  animationType: BadgeAnimationType.slide,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.red,
                  child: const Icon(Icons.shopping_cart_outlined),
                  borderRadius: BorderRadius.circular(10),
                  badgeContent: customText(settingsModel.data!.cartNumber.toString()
                      , color: Colors.white, size: 12),
                ),
                title: (getTranslated(context, "Cart",)!),
                activeColorPrimary: customColor,
                inactiveColorPrimary: HexColor("#9098B1"),
              ),

              PersistentBottomNavBarItem(
                icon: const Icon(Icons.local_offer_outlined),
                title: (getTranslated(context, "Offers",)!),
                activeColorPrimary: customColor,
                inactiveColorPrimary: HexColor("#9098B1"),
              ),

              PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.person),
                title: (
                    getTranslated(context, "Account",)!),
                activeColorPrimary: customColor,
                inactiveColorPrimary: HexColor("#9098B1"),
              ),
            ];
          }
          return settingsModel==null?
          Scaffold(
            body: const Center(
                child:  SpinKitChasingDots(
                  color: customColor,
                  size: 40,
                )),
          ):
          PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            backgroundColor: Colors.white,
            // Default is Colors.white.
            handleAndroidBackButtonPress: true,
            // Default is true.
            resizeToAvoidBottomInset: true,
            // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true,
            // Default is true.
            hideNavigationBarWhenKeyboardShows: true,

            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style6, // Choose the nav bar style with this property.
          );
        },
      ),
    );
  }



}


class FirstScreen extends StatefulWidget {
  FirstScreen(this.email, {Key? key}) : super(key: key);
  String? email;

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {


  @override
  Widget build(BuildContext context) {
    return HomeScreen(Localizations
        .localeOf(context)
        .languageCode,0,
        email: widget.email == null ? "" : widget.email);
  }
}
