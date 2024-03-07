
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackathon_proj/features/user/controller/user_controller.dart';
import 'package:hackathon_proj/routes/route_utils.dart';
import 'package:hackathon_proj/theme/font_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/snackbar.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import 'healthReport.dart';

class MoodTrackerView extends ConsumerWidget {
  MoodTrackerView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, String>> emojiList = [
    {"emoji": "😀", "label": "Happy"},
    {"emoji": "😞", "label": "Sad"},
    {"emoji": "😡", "label": "Angry"},
    {"emoji": "😮", "label": "Surprised"},
    {"emoji": "😢", "label": "Crying"},
  ];
  String? selectedEmoji;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final fontSize = ref.watch(fontSizesProvider);
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user_loading = ref.watch(userControllerProvider);
    // final user = ref.watch(userProvider)!;

    return provider.Consumer<ThemeProvider>(
      builder: (context, ThemeProvider notifier, child) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(),
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'MOOD TRACKER',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: isDarkTheme ? Colors.white : Lcream,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                'Mood Monitoring for Well-being!',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: isDarkTheme ? Colors.white54 : Lcream),
                              ),
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
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                            child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 30,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      final currentDate = DateTime.now();
                                      final userUid = FirebaseAuth.instance.currentUser!.uid;
                                      final dateString = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';

                                      // Check if the user has already submitted their mood today
                                      final querySnapshot = await FirebaseFirestore.instance
                                          .collection('moods')
                                          .where('userId', isEqualTo: userUid)
                                          .where('date', isEqualTo: dateString)
                                          .get();

                                      if (querySnapshot.docs.isNotEmpty) {
                                        // User has already submitted their mood today
                                        Fluttertoast.showToast(
                                          msg: "You have already entered your mood for today.",
                                        );
                                      } else {
                                        // No mood submitted today, show the mood selection dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('How are you feeling today?'),
                                              content: StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setState) {
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: emojiList.map((Map<String, String> item) {
                                                      return ListTile(
                                                        title: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(item["emoji"]! + " " + item["label"]!, // Display emoji and label
                                                                style: TextStyle(fontSize: 24)),
                                                          ],
                                                        ),
                                                        leading: Radio<String>(
                                                          value: item["emoji"]!,
                                                          groupValue: selectedEmoji,
                                                          onChanged: (String? value) {
                                                            setState(() {
                                                              selectedEmoji = value;
                                                            });
                                                          },
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                              actions: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    // This is where you style the container
                                                    border: Border.all(
                                            color: isDarkTheme? Dcream : Lpurple1, // // Color of the border
                                                      width: 2, // Width of the border
                                                    ),
                                                    borderRadius: BorderRadius.circular(8), // Apply border radius to all corners
                                                  ),
                                                  child: TextButton(
                                                    child: Text('Submit',
                                                    style: TextStyle(
                                                      fontSize: 18
                                                    ),),
                                                    onPressed: () async {
                                                      if (selectedEmoji != null) {
                                                        // Add the mood to Firestore
                                                        await FirebaseFirestore.instance.collection('moods').add({
                                                          'mood': selectedEmoji,
                                                          'timestamp': FieldValue.serverTimestamp(),
                                                          'userId': userUid,
                                                          'date': dateString,
                                                        });
                                                        Navigator.of(context).pop();
                                                        Fluttertoast.showToast(
                                                          msg: "Mood updated successfully!",
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: _buildMoodTrackerCard(context, isDarkTheme, "How are you feeling today?", 'assets/images/education.png', 'assets/images/educationL.png'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HealthReportView()),
                                      );
                                    },
                                    child: _buildMoodTrackerCard(context, isDarkTheme, "Mood Report", 'assets/images/moodTracker.png', 'assets/images/moodTrackerL.png'),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodTrackerCard(BuildContext context, bool isDarkTheme, String text, String darkAssetPath, String lightAssetPath) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(5.0, 5.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.grey.shade800,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(isDarkTheme ? darkAssetPath : lightAssetPath, height: 70),
          Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18),
            child: Text(
              text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDarkTheme ? Colors.black : Lcream,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hackathon_proj/features/auth/controller/auth_controller.dart';
// import 'package:hackathon_proj/features/user/controller/user_controller.dart';
// import 'package:hackathon_proj/routes/route_utils.dart';
// import 'package:hackathon_proj/theme/font_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../core/utils/snackbar.dart';
// import '../../../../theme/app_colors.dart';
// import '../../../../theme/theme_provider.dart';
// import 'package:provider/provider.dart' as provider;
//
// import 'healthReport.dart';
// class moodtrackerView extends ConsumerWidget{
//   moodtrackerView({Key? key}) : super(key: key);
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final List<String> emojis = ["😀", "😞", "😡", "😮", "😢"];
//   String? selectedEmoji;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final fontSize = ref.watch(fontSizesProvider);
//     final themeProvider = provider.Provider.of<ThemeProvider>(context);
//     bool isDarkTheme = themeProvider.isDark;
//     final user_loading = ref.watch(userControllerProvider);
//     final user = ref.watch(userProvider)!;
//     late SharedPreferences prefs; // Step 1
//
//     void _incrementClickCount() async {
//       SharedPreferences prefs = await SharedPreferences
//           .getInstance(); // Initialize the prefs variable
//       int clickCount = prefs.getInt('video_click_count') ?? 0; // Step 2
//       clickCount += 10;
//       prefs.setInt('video_click_count', clickCount); // Step 3
//     }
//     return provider.Consumer<ThemeProvider>(
//         builder: (context, ThemeProvider notifier, child) {
//         return Scaffold(
//           body: Container(
//             color: Theme.of(context).scaffoldBackgroundColor,
//             height: height,
//             width: width,
//             child: Column(
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(),
//                   width: width,
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColor,
//                           borderRadius: const BorderRadius.only(
//                             bottomRight: Radius.circular(50),
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 50),
//                             ListTile(
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 30),
//                               title: Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Text(
//                                   'MOOD TRACKER',
//                                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                                     color: isDarkTheme? Colors.white : Lcream,
//                                   ),
//                                 ),
//                               ),
//                               subtitle: Text('Mood Monitoring for Well-being!',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge
//                                       ?.copyWith(color:isDarkTheme? Colors.white54 : Lcream )),
//                               trailing: Switch(
//                                   activeColor: Dcream,
//                                   value: notifier.isDark,
//                                   onChanged: (value) => notifier.changeTheme()),
//                             ),
//                             const SizedBox(height: 30)
//                           ],
//                         ),
//                       ),
//                       Container(
//                         color: Theme.of(context).primaryColor,
//                         child: Container(
//                           height: MediaQuery.of(context).size.height / 1.5,
//                           padding: const EdgeInsets.symmetric(horizontal: 30),
//                           decoration:  BoxDecoration(
//                             color: Theme.of(context).scaffoldBackgroundColor,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(200),
//                             ),
//                           ),
//                           child: Padding(
//                             padding:
//                             const EdgeInsets.only(left: 15.0, right: 15, top: 0),
//                             child:  GridView.count(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing: 40,
//                                 mainAxisSpacing: 30,
//                                 children: [
//                                   InkWell(
//                                       onTap: () {
//                                         final currentDate = DateTime.now();
//                                         FirebaseFirestore.instance
//                                             .collection('moods')
//                                             .where('userId',
//                                             isEqualTo: FirebaseAuth
//                                                 .instance.currentUser!.uid)
//                                             .get()
//                                             .then((QuerySnapshot querySnapshot) {
//                                           if (querySnapshot.docs.isNotEmpty) {
//                                             // The user has already entered their mood for today
//                                             final dateString =
//                                                 '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
//
//                                             bool hasEnteredMoodToday = false;
//
//                                             for (var doc in querySnapshot.docs) {
//                                               print(doc['date']);
//                                               if (doc['date'] == dateString) {
//                                                 hasEnteredMoodToday = true;
//                                                 break;
//                                               }
//                                             }
//
//                                             if (hasEnteredMoodToday) {
//                                               print(
//                                                   'You have already entered your moods');
//                                               Fluttertoast.showToast(
//                                                 msg:
//                                                 "You have already entered your mood for today",
//                                               );
//                                             } else {
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (BuildContext context) {
//                                                   return AlertDialog(
//                                                     title: Text(
//                                                         'How are you feeling today?'),
//                                                     content: StatefulBuilder(
//                                                       builder: (BuildContext context,
//                                                           StateSetter setState) {
//                                                         return Column(
//                                                             mainAxisSize:
//                                                             MainAxisSize.min,
//                                                             children:
//                                                             List<Widget>.generate(
//                                                                 emojis.length,
//                                                                     (int index) {
//                                                                   return ListTile(
//                                                                     title: Text(
//                                                                         emojis[index]),
//                                                                     leading:
//                                                                     Radio<String>(
//                                                                       value:
//                                                                       emojis[index],
//                                                                       groupValue:
//                                                                       selectedEmoji,
//                                                                       onChanged: (String?
//                                                                       value) {
//                                                                         setState(() {
//                                                                           selectedEmoji =
//                                                                               value;
//                                                                         });
//                                                                       },
//                                                                     ),
//                                                                   );
//                                                                 }));
//                                                       },
//                                                     ),
//                                                     actions: <Widget>[
//                                                       TextButton(
//                                                         child: const Text('OK'),
//                                                         onPressed: () {
//                                                           final currentDate =
//                                                           DateTime.now();
//                                                           final dateString =
//                                                               '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
//                                                           FirebaseFirestore.instance
//                                                               .collection('moods')
//                                                               .where('userId',
//                                                               isEqualTo:
//                                                               FirebaseAuth
//                                                                   .instance
//                                                                   .currentUser!
//                                                                   .uid)
//                                                               .where('date',
//                                                               isEqualTo:
//                                                               dateString)
//                                                               .get()
//                                                               .then((QuerySnapshot
//                                                           querySnapshot) {
//                                                             if (querySnapshot
//                                                                 .docs.isNotEmpty) {
//                                                               // The user has already entered their mood for today
//                                                               Fluttertoast.showToast(
//                                                                 msg:
//                                                                 "You have already entered your mood for today",
//                                                               );
//                                                             } else {
//                                                               // The user has not entered their mood yet
//                                                               FirebaseFirestore
//                                                                   .instance
//                                                                   .collection('moods')
//                                                                   .add({
//                                                                 'mood': selectedEmoji,
//                                                                 'timestamp': FieldValue
//                                                                     .serverTimestamp(),
//                                                                 'userId': FirebaseAuth
//                                                                     .instance
//                                                                     .currentUser!
//                                                                     .uid,
//                                                                 'date': dateString,
//                                                               });
//
//                                                               Navigator.of(context)
//                                                                   .pop();
//                                                               // int currentCount =
//                                                               //     _prefs.getInt(
//                                                               //             'video_click_count') ??
//                                                               //         0;
//                                                               // debugPrint(
//                                                               //     'currentCount: $currentCount');
//                                                               // _prefs.setInt(
//                                                               //     'video_click_count',
//                                                               //     currentCount + 1);
//                                                             }
//                                                           });
//                                                         },
//                                                       ),
//                                                     ],
//                                                   );
//                                                 },
//                                               );
//                                             }
//                                           }
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: isDarkTheme ?Dcream:Theme.of(context)
//                                               .primaryColor, //the colour of boxes
//                                           borderRadius: BorderRadius.circular(10),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black,
//                                               offset: const Offset(
//                                                 5.0,
//                                                 5.0,
//                                               ), //Offset
//                                               blurRadius: 15.0,
//                                               spreadRadius: 1.0,
//                                             ), //BoxShadow
//                                             BoxShadow(
//                                               color: Colors.grey.shade800,
//                                               offset: const Offset(0.0, 0.0),
//                                               blurRadius: 0.0,
//                                               spreadRadius: 0.0,
//                                             ), //BoxShadow
//                                           ],
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             isDarkTheme ? Image.asset('assets/images/education.png',
//                                               height: 70,) :Image.asset('assets/images/educationL.png', height: 70,) ,
//                                             Padding(
//                                               padding: const EdgeInsets.only(left: 18.0, right: 18),
//                                               child: Text(
//                                                 "How are you feeling today?",
//                                                 maxLines: 2,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .titleMedium
//                                                     ?.copyWith(
//                                                   color: isDarkTheme
//                                                       ? Colors.black
//                                                       : Lcream,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )),
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(builder: (context) => const HealthReportView()),
//                                       );
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: isDarkTheme? Dcream : Theme.of(context)
//                                             .primaryColor, //the colour of boxes
//                                         borderRadius: BorderRadius.circular(10),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black,
//                                             offset: const Offset(
//                                               5.0,
//                                               5.0,
//                                             ), //Offset
//                                             blurRadius: 15.0,
//                                             spreadRadius: 1.0,
//                                           ), //BoxShadow
//                                           BoxShadow(
//                                             color: Colors.grey.shade800,
//                                             offset: const Offset(0.0, 0.0),
//                                             blurRadius: 0.0,
//                                             spreadRadius: 0.0,
//                                           ), //BoxShadow
//                                         ],
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           isDarkTheme ? Image.asset('assets/images/moodTracker.png',
//                                             height: 110,) :Image.asset('assets/images/moodTrackerL.png', height: 110,) ,
//                                           const SizedBox(height: 8),
//                                           Text(
//                                             "Mood Report",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleMedium
//                                                 ?.copyWith(
//                                               color:
//                                               isDarkTheme ? Colors.black : Lcream,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                             // GridView.builder(
//                             //   gridDelegate:
//                             //   const SliverGridDelegateWithFixedCrossAxisCount(
//                             //     crossAxisCount: 2,
//                             //     childAspectRatio: (1.12 / 0.9),
//                             //     mainAxisSpacing: 5,
//                             //     crossAxisSpacing: 1,
//                             //   ),
//                             //   shrinkWrap: true,
//                             //   physics: const NeverScrollableScrollPhysics(),
//                             //   itemCount: 3,
//                             //   itemBuilder: (context, index) {
//                             //     return InkWell(
//                             //       onTap: () {
//                             //         switch (index) {
//                             //           case 0:
//                             //           // Navigate to Report and Recommendation Page
//                             //             Navigation.navigateToEducationVideos(context);
//                             //             break;
//                             //           case 1:
//                             //           // Navigate to Community Page
//                             //             Navigation.navigateToEducationAudios(context);
//                             //             break;
//                             //           case 2:
//                             //           // Navigate to Medicare Page
//                             //             Navigation.navigateToEducationReading(
//                             //                 context);
//                             //             break;
//                             //
//                             //           default:
//                             //           // Handle any undefined index
//                             //             Fluttertoast.showToast(
//                             //               msg: "This page is under construction",
//                             //             );
//                             //             break;
//                             //         }
//                             //       },
//                             //       child: Container(
//                             //         margin: const EdgeInsets.symmetric(
//                             //             vertical: 8, horizontal: 20),
//                             //         decoration: BoxDecoration(
//                             //           borderRadius: BorderRadius.circular(20),
//                             //           color: isDarkTheme ? Dcream : Lpurple1,
//                             //           boxShadow: const [
//                             //             BoxShadow(
//                             //               color: Colors.grey,
//                             //               spreadRadius: 0.3,
//                             //               blurRadius: 1,
//                             //             )
//                             //           ],
//                             //         ),
//                             //         child: Column(
//                             //           mainAxisAlignment:
//                             //           MainAxisAlignment.spaceEvenly,
//                             //           children: [
//                             //             // Image.asset(imgData[index]),
//                             //             Text(
//                             //               tabs[index],
//                             //               textAlign: TextAlign.center,
//                             //               style: Theme.of(context)
//                             //                   .textTheme
//                             //                   .headlineMedium!
//                             //                   .copyWith(
//                             //                 fontSize: fontSize.fontSize,
//                             //               ),
//                             //             ),
//                             //           ],
//                             //         ),
//                             //       ),
//                             //     );
//                             //   },
//                             // ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ) ,
//         );
//       }
//     );
//   }
//
// }
// //
// //
// //
// // final List tabs = [
// //   "How are you feeling today?",
// //   "Mood Report",
// // ];
// //
// // class moodtrackerView extends ConsumerWidget {
// //   moodtrackerView({Key? key}) : super(key: key);
// //
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final height = MediaQuery.of(context).size.height;
// //     final width = MediaQuery.of(context).size.width;
// //     final fontSize = ref.watch(fontSizesProvider);
// //     final themeProvider = provider.Provider.of<ThemeProvider>(context);
// //     bool isDarkTheme = themeProvider.isDark;
// //     final user_loading = ref.watch(userControllerProvider);
// //     final user = ref.watch(userProvider)!;
// //     return provider.Consumer<ThemeProvider>(
// //         builder: (context, ThemeProvider notifier, child) {
// //           return Scaffold(
// //             key: _scaffoldKey,
// //             body: Container(
// //               color: Theme.of(context).scaffoldBackgroundColor,
// //               height: height,
// //               width: width,
// //               child: Column(
// //                 children: [
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color: Theme.of(context).primaryColor,
// //                       borderRadius: const BorderRadius.only(
// //                         bottomRight: Radius.circular(50),
// //                       ),
// //                     ),
// //
// //                     child: Column(
// //                       children: [
// //                         const SizedBox(height: 50),
// //                         ListTile(
// //                           contentPadding: const EdgeInsets.symmetric(horizontal: 30),
// //                           title: Padding(
// //                             padding: const EdgeInsets.only(top: 8.0),
// //                             child: Text(
// //                               'SERVICES',
// //                               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
// //                                 color: isDarkTheme? Colors.white : Lcream,
// //                               ),
// //                             ),
// //                           ),
// //                           subtitle: Text('Linking Hands with Helpers!',
// //                               style: Theme.of(context)
// //                                   .textTheme
// //                                   .titleLarge
// //                                   ?.copyWith(color:isDarkTheme? Colors.white54 : Lcream )),
// //                           trailing: Switch(
// //                               activeColor: Dcream,
// //                               value: notifier.isDark,
// //                               onChanged: (value) => notifier.changeTheme()),
// //                         ),
// //                         const SizedBox(height: 30)
// //                       ],
// //                     ),
// //                   ),
// //
// //                   Container(
// //                     color: Theme.of(context).primaryColor,
// //                     child: Container(
// //                       height: MediaQuery.of(context).size.height / 1.8,
// //                       padding: const EdgeInsets.symmetric(horizontal: 30),
// //                       decoration:  BoxDecoration(
// //                         color: Theme.of(context).scaffoldBackgroundColor,
// //                         borderRadius: BorderRadius.only(
// //                           topLeft: Radius.circular(200),
// //                         ),
// //                       ),
// //
// //
// //                       child :  Padding(
// //                         padding:
// //                         const EdgeInsets.only(left: 15.0, right: 15, top: 0),
// //                         child:
// //                         GridView.count(
// //                             shrinkWrap: true,
// //                             physics: const NeverScrollableScrollPhysics(),
// //                             crossAxisCount: 2,
// //                             crossAxisSpacing: 40,
// //                             mainAxisSpacing: 30,
// //                             children: [
// //                               InkWell(
// //                                   onTap: () {
// //                                     Navigation.navigateToEducation(context);
// //                                   },
// //                                   child: Container(
// //                                     decoration: BoxDecoration(
// //                                       color: isDarkTheme ?Dcream:Theme.of(context)
// //                                           .primaryColor, //the colour of boxes
// //                                       borderRadius: BorderRadius.circular(10),
// //                                       boxShadow: [
// //                                         BoxShadow(
// //                                           color: Colors.black,
// //                                           offset: const Offset(
// //                                             5.0,
// //                                             5.0,
// //                                           ), //Offset
// //                                           blurRadius: 15.0,
// //                                           spreadRadius: 1.0,
// //                                         ), //BoxShadow
// //                                         BoxShadow(
// //                                           color: Colors.grey.shade800,
// //                                           offset: const Offset(0.0, 0.0),
// //                                           blurRadius: 0.0,
// //                                           spreadRadius: 0.0,
// //                                         ), //BoxShadow
// //                                       ],
// //                                     ),
// //                                     child: Column(
// //                                       mainAxisAlignment: MainAxisAlignment.center,
// //                                       children: [
// //                                         isDarkTheme ? Image.asset('assets/images/education.png',
// //                                           height: 110,) :Image.asset('assets/images/educationL.png', height: 110,) ,
// //                                         Text(
// //                                           "Education",
// //                                           style: Theme.of(context)
// //                                               .textTheme
// //                                               .titleMedium
// //                                               ?.copyWith(
// //                                             color: isDarkTheme
// //                                                 ? Colors.black
// //                                                 : Lcream,
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   )),
// //                               InkWell(
// //                                 onTap: () {
// //
// //                                 },
// //                                 child: Container(
// //                                   decoration: BoxDecoration(
// //                                     color: isDarkTheme? Dcream : Theme.of(context)
// //                                         .primaryColor, //the colour of boxes
// //                                     borderRadius: BorderRadius.circular(10),
// //                                     boxShadow: [
// //                                       BoxShadow(
// //                                         color: Colors.black,
// //                                         offset: const Offset(
// //                                           5.0,
// //                                           5.0,
// //                                         ), //Offset
// //                                         blurRadius: 15.0,
// //                                         spreadRadius: 1.0,
// //                                       ), //BoxShadow
// //                                       BoxShadow(
// //                                         color: Colors.grey.shade800,
// //                                         offset: const Offset(0.0, 0.0),
// //                                         blurRadius: 0.0,
// //                                         spreadRadius: 0.0,
// //                                       ), //BoxShadow
// //                                     ],
// //                                   ),
// //                                   child: Column(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     children: [
// //                                       isDarkTheme ? Image.asset('assets/images/moodTracker.png',
// //                                         height: 110,) :Image.asset('assets/images/moodTrackerL.png', height: 110,) ,
// //                                       const SizedBox(height: 8),
// //                                       Text(
// //                                         "Mood Tracker",
// //                                         style: Theme.of(context)
// //                                             .textTheme
// //                                             .titleMedium
// //                                             ?.copyWith(
// //                                           color:
// //                                           isDarkTheme ? Colors.black : Lcream,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ]),
// //
// //                       ),
// //
// //
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //           );
// //         });
// //   }
// // }
