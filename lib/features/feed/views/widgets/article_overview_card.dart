import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/features/feed/views/feed/blog/article_details_view.dart';
import 'package:hackathon_proj/features/user/controller/user_controller.dart';
import 'package:hackathon_proj/theme/app_colors.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../core/common/error_text.dart';
import '../../../../core/common/loader.dart';
import '../../../../models/article_model.dart';
import '../../../../theme/theme_provider.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/feed_controller.dart';

// ignore: must_be_immutable
class PostOverviewCard extends ConsumerStatefulWidget {
  Articles articles;
  PostOverviewCard({super.key, required this.articles});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostOverviewCardState();
}

class _PostOverviewCardState extends ConsumerState<PostOverviewCard> {
  void deleteArticle(WidgetRef ref, BuildContext context) async {
    ref
        .read(articleControllerProvider.notifier)
        .deleteArticle(widget.articles, context);
  }

  void upVote(WidgetRef ref, BuildContext context) async {
    ref.read(articleControllerProvider.notifier).upVote(widget.articles);
  }

  void downVote(WidgetRef ref, BuildContext context) async {
    ref.read(articleControllerProvider.notifier).downVote(widget.articles);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider)!;
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    print('Card Build Method called');
    return ref.watch(getUserDataByIdProvider(widget.articles.author)).when(
          data: (user) {
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Ink.image(
                          height: 240,
                          onImageError: (exception, stackTrace) => Image.asset(
                            'assets/images/js.jpg',
                            fit: BoxFit.contain,
                            height: 240,
                          ),
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.articles.bannerImage.toString(),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => ArticleScreen(
                                    articleId: widget.articles.id)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 16,
                      //   right: 16,
                      //   left: 16,
                      //   child:
                      // )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 10, top: 3),
                    child: Row(
                      children: [
                        Text(
                          "Title: ",
                          textAlign: TextAlign.left,
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Dcream : Lpurple1,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.articles.title.toString(),
                          textAlign: TextAlign.left,
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Dcream : Lpurple1,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0)
                        .copyWith(bottom: 0, top: 5),
                    child: Row(
                      children: [
                        Text(
                          "Description: ",
                          textAlign: TextAlign.left,
                          style:  TextStyle(

                            color: isDarkTheme ? Dcream : Lpurple1,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: SelectableText(
                            widget.articles.brief.toString(),
                          
                            style:TextStyle(fontSize: 15,
                              color: isDarkTheme ? Dcream : Lpurple1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profilePicture),
                              foregroundImage:
                                  NetworkImage(user.profilePicture),
                              backgroundColor:  isDarkTheme ? Dcream : Lpurple1,
                              radius: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              user.name.toString().length > 10
                                  ? user.name.substring(0, 10)
                                  : user.name,
                              // widget.widget.articles.author!,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:  isDarkTheme ? Dcream : Lpurple1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height:
                                  MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple[200],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              child: Center(
                                child: Text(
                                  widget.articles.category.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => upVote(ref, context),
                              icon: Icon(
                                Icons.thumb_up,
                                color: widget.articles.upVotes
                                        .contains(currentUser.email)
                                    ? Colors.red
                                    :  isDarkTheme ? Dcream : Lpurple1,
                                size:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                            Text(
                              '${widget.articles.upVotes.length - widget.articles.downVotes.length == 0 ? 'Vote' : widget.articles.upVotes.length - widget.articles.downVotes.length}',
                            ),
                            IconButton(
                              onPressed: () => downVote(ref, context),
                              icon: Icon(
                                Icons.thumb_down,
                                color: widget.articles.downVotes
                                        .contains(currentUser.email)
                                    ? Colors.red
                                    : isDarkTheme ? Dcream : Lpurple1,
                                size:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => ArticleScreen(
                                    articleId: widget.articles.id)),
                              ),),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height:
                            MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.deepPurple[200],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Center(
                              child: Text(
                                "Explore",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        if (widget.articles.author == currentUser.email)
                          IconButton(
                            onPressed: () => deleteArticle(ref, context),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.width * 0.08,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
