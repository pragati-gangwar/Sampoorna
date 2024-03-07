import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:url_launcher/url_launcher.dart';
import '../../../../../models/news_model.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/theme_provider.dart';

class DetailsScreenNews extends StatelessWidget {
  final NewsData newsData;
  const DetailsScreenNews({super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        toolbarHeight: 60,
        centerTitle: true,
        elevation: 0,
        title: Center(
          child: Text(newsData.title,
            style: TextStyle(
              fontSize: 20,
              color: isDarkTheme ? Colors.white : Lcream,

            ),
            maxLines: 4,  // Allows text to wrap to a second line
            overflow: TextOverflow.ellipsis, ),
        ),
        ),

      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 120, horizontal: 10),
        children: [
          Container(
            height: 300,
            child: Image.network(
              newsData.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.only(bottom: 100),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title: ",
                    style: Theme.of(context).textTheme.titleMedium,),
                  SizedBox(height: 10),
                  Text(
                    newsData.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 8,
                  ),
                  const SizedBox(height: 20),
                  Text("Author: ",
                  style: Theme.of(context).textTheme.titleMedium,),
                  SizedBox(width: 10,),
                  Text(
                    newsData.author,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 20),
                  Text("Description: ",
                    style: Theme.of(context).textTheme.titleMedium,),

                  const SizedBox(height: 10),
                  Text(
                    newsData.description,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  const SizedBox(height: 20),
                  Text("Complete news: ",
                    style: Theme.of(context).textTheme.titleMedium,),

                  const SizedBox(height: 10),
                  Text(
                    newsData.writeup,
                    textAlign: TextAlign.justify,

                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // Removed maxLines and overflow
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    child: Text(
                      "[Click here to read complete news]",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.blue, // Make the text color blue (or any other color you prefer for links)
                        fontWeight: FontWeight.w600,
                        fontSize: 20// Underline to make it look like a link
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      final url = newsData.url;
                      late Uri _url = Uri.parse(url);
                      Future<void> _launchUrl() async {
                      if (!await launchUrl(_url)) {}

                      }
                      _launchUrl();



                    },
                  ),

                ],
              ),
            ),
          )
        ],
      ),
      // bottomSheet: Container(
      //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
      //   width: double.infinity,
      //   child: ElevatedButton(
      //     onPressed: () {},
      //     style: ElevatedButton.styleFrom(
      //         padding: const EdgeInsets.all(15),
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(50)
      //         )
      //     ),
      //     child: const Text('Add to bookmarks'),
      //   ),
      // ),
    );
  }
}
