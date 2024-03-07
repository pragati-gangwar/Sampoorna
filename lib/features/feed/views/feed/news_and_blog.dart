import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/snackbar.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/theme_provider.dart';
import '../../../SOS/add_conatacts.dart';
import '../../../dashboard/widgets/bottom_bar.dart';
import 'blog/home_screen_blogs.dart';
import 'blog/welcome_screen_blog.dart';
import 'package:provider/provider.dart' as provider;
import 'news/home_screen_news.dart';
import 'news/welcome_screen_news.dart';

class FeedHome extends ConsumerStatefulWidget {
  const FeedHome({super.key});

  @override
  ConsumerState<FeedHome> createState() => _FeedHomeState();
}

class _FeedHomeState extends ConsumerState<FeedHome> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
        return Scaffold(
          body: Column(
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
                          'FEED',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: isDarkTheme? Colors.white : Lcream,
                              ),
                        ),
                      ),
                      subtitle: Text('A world of exploration!',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color:isDarkTheme? Colors.white54 : Lcream )),
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
                  height: MediaQuery.of(context).size.height / 1.25,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration:  BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                    ),
                  ),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 30,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreenNews ()));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const WelcomeScreenNews()),
                          // );
                        },
                        child: itemDashboard(
                          title: 'News',
                          img: "assets/images/news.png",
                          img1: "assets/images/newsL.png",
                          isDarkTheme: isDarkTheme ? true : false,
                          textColor: isDarkTheme ? Colors.black : Lcream,
                          backgroundColor: isDarkTheme ? Dcream : Lpurple1,
                        ),
                      ),
                      InkWell(
                        onTap: () {

                          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreenBlog ()));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const WelcomeScreenBlog()),
                          // );
                        },
                        child: itemDashboard(
                          title: 'Blogs',
                          img: "assets/images/blogs.png",
                          img1: "assets/images/blogsL.png",
                          isDarkTheme: isDarkTheme ? true : false,
                          textColor: isDarkTheme ? Colors.black : Lcream,
                          backgroundColor: isDarkTheme ? Dcream : Lpurple1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        );
      }
    );
  }

  Widget itemDashboard({
    required String title,
    required String img,
    required String img1,
    required Color backgroundColor,
    required Color textColor,
    required bool isDarkTheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, //the colour of boxes
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
        // boxShadow: [
        //   BoxShadow(
        //     offset: const Offset(0, 5),
        //     color: Colors.black,
        //     color: Theme.of(context).primaryColor.withOpacity(.2),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //   )
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isDarkTheme ? Image.asset('${img}',
            height: 110,) :Image.asset('${img1}', height: 110,) ,
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
    );

  }
}
