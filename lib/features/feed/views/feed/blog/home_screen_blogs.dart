import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/common/error_text.dart';
import '../../../../../core/common/loader.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/theme_provider.dart';
import '../../../controller/feed_controller.dart';
import 'write_blog.dart';
import '../../widgets/article_overview_card.dart';
import 'package:provider/provider.dart' as provider;
class HomeScreenBlog extends ConsumerWidget {
  const HomeScreenBlog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Blogs",
          style: TextStyle(
            fontSize: 24,
            color: isDarkTheme ? Colors.white : Lcream,
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ref.watch(userArticleProvider).when(
              data: (data) {
                print(data[0].brief);
                return ListView.builder(
                  physics:
                      const ClampingScrollPhysics(), // By Using this List Become Scrollable
                  controller: ScrollController(initialScrollOffset: 0),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final articles = data[index];
                    return PostOverviewCard(
                      articles: articles,
                    );
                  },
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkTheme ?Dcream :Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WriteBlog()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.upload, size: 30,
        color: Colors.black,),
      ),
    );
  }
}
