import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart' as provider;
import '../../../core/utils/snackbar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import 'package:hackathon_proj/theme/font_provider.dart';

import '../SOS/add_conatacts.dart';
import '../dashboard/widgets/bottom_bar.dart';
import 'dialogflowBot.dart';
import 'geminiBot.dart';


final List imgData=[
  "assets/images/ChatBot.png",
  "assets/images/HelpBot.png",
];

final List tabs = [
  "Help Bot",
  "Chat Bot",

];
class chatBotMainPage extends StatefulWidget {
  const chatBotMainPage({super.key});

  @override
  State<chatBotMainPage> createState() => _chatBotMainPageState();
}

class _chatBotMainPageState extends State<chatBotMainPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Bot Support"),
              actions:[ Switch(
                  activeColor: Dcream,
                  value: notifier.isDark,
                  onChanged: (value) => notifier.changeTheme()),],

            ),
            body: Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15, top: 40),
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (1.5 / 1.5),
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 1,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      switch (index) {
                        case 0:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Chat()),
                          );
                          break;
                        case 1:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyHomePage()),
                          );
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
                          Container(
                              height: 100,
                              width: 100,
                              child: Image.asset(imgData[index])),
                          Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                              fontSize: 24,
                              color: isDarkTheme ? Dbrown1 : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton.large(
              backgroundColor: Colors.red.shade400,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddContactsPage()),
                );
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
            bottomNavigationBar: const BottomBar(),
          );
        }
    );
  }
}