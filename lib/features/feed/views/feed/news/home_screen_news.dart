import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hackathon_proj/apis/apis.dart';
import 'package:hackathon_proj/features/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../../models/news_model.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/theme_provider.dart';
import '../../widgets/item_travel_news.dart';

import 'package:http/http.dart' as http;

class HomeScreenNews extends ConsumerStatefulWidget {
  const HomeScreenNews({super.key});

  @override
  ConsumerState createState() => HomeScreenNewsState();
}

class HomeScreenNewsState extends ConsumerState<HomeScreenNews> {
  String searchQuery = '';
  List<NewsData> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiUrl =
        'https://newsapi.org/v2/everything?q=accessibility&apiKey=f61018259285447c93ce60952f2546e6';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        setState(() {
          newsList = articles
              .map((article) =>
              NewsData.fromMap(article as Map<String, dynamic>))
              .toList();
          isLoading = false;
        });
      } else {
        // Handle errors
        setState(() {
          isLoading = false; // Set loading to false if there's an error
        });
        print('Failed to load news. Error ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        isLoading = false; // Set loading to false if there's an error
      });
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    print(newsList);
    List<NewsData> filteredNews = newsList.where((news) {
      final titleLower = news.title.toLowerCase();
      final descriptionLower = news.description.toLowerCase();
      final authorLower = news.author.toLowerCase();
      final queryLower = searchQuery.toLowerCase();

      return titleLower.contains(queryLower) ||
          descriptionLower.contains(queryLower) ||
          authorLower.contains(queryLower);
    }).toList();
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title: Text("News",
          style: TextStyle(
            fontSize: 24,
            color: isDarkTheme ? Colors.white : Lcream,
          ),),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
            child: CircularProgressIndicator()) // Show loading indicator
            : buildContent(context), // Extracted method for building content
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user = ref.watch(userProvider)!;
    print(newsList);
    List<NewsData> filteredNews = newsList.where((news) {
      final titleLower = news.title.toLowerCase();
      final descriptionLower = news.description.toLowerCase();
      final authorLower = news.author.toLowerCase();
      final queryLower = searchQuery.toLowerCase();

      return titleLower.contains(queryLower) ||
          descriptionLower.contains(queryLower) ||
          authorLower.contains(queryLower);
    }).toList();
    // Your existing SingleChildScrollView and its children go here
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 10),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Theme
                  .of(context)
                  .primaryColor,

              height: 33,
              child: Center(
                child: Text(
                  "News Tailored for the Differently-Abled",
                  style: TextStyle(color: isDarkTheme ? Colors.white : Theme
                      .of(context)
                      .scaffoldBackgroundColor, height: 1,
                    fontSize: 19,
                    overflow: TextOverflow.visible,),
                ),
              )

          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        color:
                        Theme
                            .of(context)
                            .primaryColor
                            .withOpacity(.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon:
                      Icon(CupertinoIcons.search, color: Colors.grey),
                      filled: true,
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  margin: const EdgeInsets.only(top: 15),
                ),
                GridView.count(
                  padding: const EdgeInsets.only(top: 10),
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                  physics: NeverScrollableScrollPhysics(),
                  children: filteredNews.map((newsData) {
                    return ItemTravelNews(
                      newsData: newsData,
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}