import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackathon_proj/features/auth/controller/auth_controller.dart';
import 'package:hackathon_proj/features/user/controller/user_controller.dart';
import 'package:hackathon_proj/routes/route_utils.dart';
import 'package:hackathon_proj/theme/font_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/snackbar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../dashboard/widgets/shimmer.dart';

final List tabs = [
  "Documents",
  "Prescription",
  "Appointment",
];

class HealthHomeView extends ConsumerWidget {
  HealthHomeView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'MEDICARE',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: isDarkTheme ? Colors.white : Lcream,
                              ),
                        ),
                      ),
                      subtitle: Text(
                          'Safekeeping records, timely reminders, and scheduled care!',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: isDarkTheme ? Colors.white54 : Lcream,
                                  fontSize: 22)),
                      trailing: Switch(
                          activeColor: Dcream,
                          value: notifier.isDark,
                          onChanged: (value) => notifier.changeTheme()),
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(),
                width: width,
                child: Column(
                  children: [
                    Container(
                        color: Theme.of(context).primaryColor,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(200),
                            ),
                          ),
                          child:
                          GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 30,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigation.navigateMyDocument(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isDarkTheme ? Dcream :Theme.of(context)
                                            .primaryColor, //the colour of boxes
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: const Offset(
                                              5.0,
                                              5.0,
                                            ), //Offset
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0,
                                          ), //BoxShadow
                                          BoxShadow(
                                            color: Colors.grey.shade800,
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isDarkTheme ? Image.asset('assets/images/DocumentsD.png',
                                            height: 110,) :Image.asset('assets/images/Documents.png', height: 110,) ,
                                          Text(
                                            "Documents",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: isDarkTheme
                                                      ? Colors.black
                                                      : Lcream,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )),
                                InkWell(
                                  onTap: () {
                                    Navigation.navigateToAppointmentCalender(
                                        context);

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => const WelcomeScreenBlog()),
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDarkTheme ? Dcream :Theme.of(context)
                                          .primaryColor, //the colour of boxes
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: const Offset(
                                            5.0,
                                            5.0,
                                          ), //Offset
                                          blurRadius: 15.0,
                                          spreadRadius: 1.0,
                                        ), //BoxShadow
                                        BoxShadow(
                                          color: Colors.grey.shade800,
                                          offset: const Offset(0.0, 0.0),
                                          blurRadius: 0.0,
                                          spreadRadius: 0.0,
                                        ), //BoxShadow
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isDarkTheme ? Image.asset('assets/images/appoinmentsD.png',
                                          height: 110,) :Image.asset('assets/images/appoinments.png', height: 110,) ,
                                        Text(
                                          "Appointment Alarm",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: isDarkTheme
                                                    ? Colors.black
                                                    : Lcream,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigation.navigateToPrescriptionCalender(
                                        context);

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => const WelcomeScreenBlog()),
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDarkTheme ? Dcream : Theme.of(context)
                                          .primaryColor, //the colour of boxes
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: const Offset(
                                            5.0,
                                            5.0,
                                          ), //Offset
                                          blurRadius: 15.0,
                                          spreadRadius: 1.0,
                                        ), //BoxShadow
                                        BoxShadow(
                                          color: Colors.grey.shade800,
                                          offset: const Offset(0.0, 0.0),
                                          blurRadius: 0.0,
                                          spreadRadius: 0.0,
                                        ), //BoxShadow
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isDarkTheme ? Image.asset('assets/images/PrescriptionD.png',
                                          height: 110,) :Image.asset('assets/images/Prescription.png', height: 110,) ,
                                        Text(
                                          "Prescription Alarm",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: isDarkTheme
                                                    ? Colors.black
                                                    : Lcream,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                          // Padding(
                          //      padding:
                          //          const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                          //      child: GridView.builder(
                          //        gridDelegate:
                          //            const SliverGridDelegateWithFixedCrossAxisCount(
                          //          crossAxisCount: 2,
                          //          childAspectRatio: (1.12 / 0.9),
                          //          mainAxisSpacing: 5,
                          //          crossAxisSpacing: 1,
                          //        ),
                          //        shrinkWrap: true,
                          //        physics: const NeverScrollableScrollPhysics(),
                          //        itemCount: 3,
                          //        itemBuilder: (context, index) {
                          //          return InkWell(
                          //            onTap: () {
                          //              switch (index) {
                          //                case 0:
                          //                  // Navigate to Report and Recommendation Page
                          //
                          //                  break;
                          //                case 1:
                          //                  // Navigate to Community Page
                          //
                          //                  break;
                          //                case 2:
                          //                  // Navigate to Medicare Page
                          //                  Navigation.navigateToAppointmentCalender(
                          //                      context);
                          //                  break;
                          //
                          //                default:
                          //                  // Handle any undefined index
                          //                  Fluttertoast.showToast(
                          //                    msg: "This page is under construction",
                          //                  );
                          //                  break;
                          //              }
                          //            },
                          //            child: Container(
                          //              margin: const EdgeInsets.symmetric(
                          //                  vertical: 8, horizontal: 20),
                          //              decoration: BoxDecoration(
                          //                borderRadius: BorderRadius.circular(20),
                          //                color: isDarkTheme ? Dcream : Lpurple1,
                          //                boxShadow: const [
                          //                  BoxShadow(
                          //                    color: Colors.grey,
                          //                    spreadRadius: 0.3,
                          //                    blurRadius: 1,
                          //                  )
                          //                ],
                          //              ),
                          //              child: Column(
                          //                mainAxisAlignment:
                          //                    MainAxisAlignment.spaceEvenly,
                          //                children: [
                          //                  // Image.asset(imgData[index]),
                          //                  Text(
                          //                    tabs[index],
                          //                    textAlign: TextAlign.center,
                          //                    style: Theme.of(context)
                          //                        .textTheme
                          //                        .headlineMedium!
                          //                        .copyWith(
                          //                          fontSize: fontSize.fontSize,
                          //                        ),
                          //                  ),
                          //                ],
                          //              ),
                          //            ),
                          //          );
                          //        },
                          //      ),
                          //    ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.red.shade400,
          shape: const CircleBorder(),
          onPressed: () {
            // Get.to(() => AddContactsPage());
            successSnackBar(
                context: context,
                message:
                    'Your Community "Jffffffffffffffffffffff" Created Successfully!',
                title: 'Success');
          },
          child: const Icon(
            Icons.sos_rounded,
            size: 48,
            color: Dbrown1,
          ),
          elevation: 2.0,
        ),
      );
    });
  }
}
