import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackathon_proj/core/utils/notification_service.dart';
import 'package:hackathon_proj/features/auth/controller/auth_controller.dart';
import 'package:hackathon_proj/features/user/controller/user_controller.dart';
import 'package:hackathon_proj/routes/route_utils.dart';
import 'package:hackathon_proj/theme/font_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/snackbar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../SOS/add_conatacts.dart';
import '../../SOS/contact_model.dart';
import '../../SOS/db_services.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/menu.dart';
import '../widgets/shimmer.dart';

final List tabs = [
  "Report & Recommendation",
  "Community",
  "Medicare",
  "Connect Me",
  "Services",
  "Feed"
];
final List img = [
  "assets/images/repo&rec.png",
  "assets/images/community.png",
  "assets/images/medicare.png",
  "assets/images/connectMe.png",
  "assets/images/services.png",
  "assets/images/feed.png",







];
final List imgL = [
  "assets/images/repo&recL.png",
  "assets/images/communityL.png",
  "assets/images/medicareL.png",
  "assets/images/connectMeL.png",
  "assets/images/servicesL.png",
  "assets/images/feedL.png",



];

class DashboardHomeView extends ConsumerStatefulWidget {
  const DashboardHomeView({super.key});

  @override
  ConsumerState<DashboardHomeView> createState() => _DashboardHomeViewState();
}

class _DashboardHomeViewState extends ConsumerState<DashboardHomeView> {
  // sos
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;
  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "send");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are  denind");
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
        Fluttertoast.showToast(
            msg: "Location permissions are permanently denind");
      }
    }
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _curentPosition = position;
        print(_curentPosition!.latitude);
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
        "${place.locality},${place.subLocality},${place.street},${place.postalCode},${place.country}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAndSendSms() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "https://maps.google.com/?daddr=${_curentPosition!.latitude},${_curentPosition!.longitude}";
    if (await _isPermissionGranted()) {
      contactList.forEach((element) {
        _sendSms("${element.number}", "i am in trouble $messageBody");
      });
    } else {
      Fluttertoast.showToast(msg: "something wrong");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int clickCount = 0;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        getAndSendSms();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shake!'),
          ),
        );
        // Do stuff on phone shake
      },
      minimumShakeCount: 4,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
    _incrementClickCount();
  }

  Future<void> _incrementClickCount() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCount = _prefs.getInt('video_click_count') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final fontSize = ref.watch(fontSizesProvider);
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user_loading = ref.watch(userControllerProvider);
    final user = ref.watch(userProvider)!;
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
          key: _scaffoldKey,
          drawer: const MenuDrawer(),
          body: Stack(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                height: height,
                width: width,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      width: width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 35.0, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon:  Icon(
                                    Icons.menu,
                                    size: 40,
                                    color: isDarkTheme ? Dcream : Lcream,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.heavyImpact();
                                    _scaffoldKey.currentState
                                        ?.openDrawer(); // This line opens the drawer.
                                  },
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      height: 37,
                                      decoration: BoxDecoration(
                                       //DecorationImage
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 8,
                                        ), //Border.all
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [

                                          BoxShadow(
                                            color: Colors.white,
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ), //
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.monetization_on,
                                              color: Dcream,
                                              size: 26,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(clickCount.toString(),
                                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Switch(
                                      activeColor: Dcream,
                                      value: notifier.isDark,
                                      onChanged: (value) {
                                        HapticFeedback.heavyImpact();
                                        notifier.changeTheme();
                                      }
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              left: 30,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                user_loading
                                    ? const TshimerEffect(width: 80, height: 15)
                                    : Text(
                                        "Hello, ${user.name}!",
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              color:
                                                  isDarkTheme ? Dcream : Lcream,
                                              fontSize: fontSize.headingSize,
                                            ),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Welcome to SAMPOORNA – Redefining Accessibility, Limitlessly!",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: isDarkTheme ? Dcream : Lcream,
                                        fontSize: fontSize.subheadingSize,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? dashboard
                              : Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (1.12 / 0.9),
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 1,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  switch (index) {
                                    case 0:
                                      // Navigate to Report and Recommendation Page
                                      Navigation
                                          .navigateToReportandRecommendation(
                                              context);
                                      break;
                                    case 1:
                                      // Navigate to Community Page
                                      Navigation.navigateCommunityHome(context);
                                      // Navigator.push(context, MaterialPageRoute(builder: (_) => const groupsHome ()));

                                      break;
                                    case 2:
                                      // Navigate to Medicare Page
                                      Navigation.navigateHealthHome(context);
                                      break;
                                    case 3:
                                      // Navigate to Connect Me Page
                                      Navigation.navigateToCounsellorHome(
                                        context,
                                      );
                                      break;
                                    case 4:
                                      // Navigate to Services Page
                                      Navigation.navigateToServices(context);
                                      break;
                                    case 5:
                                      Navigation.navigateToFeed(context);
                                      break;
                                    default:
                                      // Handle any undefined index
                                      Fluttertoast.showToast(
                                        msg: "This page is under construction",
                                      );
                                      break;
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isDarkTheme ? Dcream : Lpurple1,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 0.3,
                                        blurRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      isDarkTheme ? Image.asset(img[index],
                                      width: 90,
                                      height: 90,):
                                      Image.asset(imgL[index],
                                        width: 90,
                                        height: 90,),
                                      Padding(
                                        padding: const EdgeInsets.only(left:1.0, right:1),
                                        child: Text(
                                          tabs[index],
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                fontSize: fontSize.fontSize,

                                            color:isDarkTheme ? Colors.black : Lcream)

                                              ),
                                        ),

                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: (MediaQuery. of(context). size. height)/2,
                child: Container(
                  width: 40,
                  
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDarkTheme ? Dcream : Lpurple1,
                      width: 1,
                    ), //Border.all
                    borderRadius: BorderRadius.circular(15),
                    color: isDarkTheme ? Dbrown3 : Lpurple3,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: const Offset(
                          5.0,
                          5.0,
                        ), //Offset
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                  ), //BoxDecoration

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(0),
                        icon: const Icon(Icons.add,
                        ),
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          ref.read(fontSizeManager).increaseAllFontSizes(ref);
                        },
                      ),
                      Center(
                        heightFactor: 0.4,
                        child: Text("A",
                        style: TextStyle(
                            fontSize: 24,
                          fontWeight: FontWeight.w500,


                        ),),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          ref.read(fontSizeManager).decreaseAllFontSizes(ref);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.large(
            backgroundColor: Colors.red.shade400,
            shape: const CircleBorder(),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddContactsPage()),
              );
              // // Get.to(() => AddContactsPage());
              // NotificationService().showNotification(
              //     id: 0, title: 'New Notification', body: 'nothing');



            },
            child: const Icon(
              Icons.sos_rounded,
              size: 48,
              color: Dbrown1,
            ),
            elevation: 2.0,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const BottomBar()

          );
    });
  }
}
