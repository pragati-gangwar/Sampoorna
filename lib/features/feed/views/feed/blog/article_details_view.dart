
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../../core/common/error_text.dart';
import '../../../../../core/common/loader.dart';
import '../../../../../theme/theme_provider.dart';
import '../../../../user/controller/user_controller.dart';
import '../../../controller/feed_controller.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final String? articleId;
  const ArticleScreen({required this.articleId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;

    return ref.watch(getArticleByIdProvider(widget.articleId!)).when(
      data: (article) {
        return ref.watch(getUserDataByIdProvider(article.author.toString())).when(
          data: (user) {
            return Scaffold(
              appBar: AppBar(
                // title: const Text('Reading Materials'),
                centerTitle: true, // Center the title
                // You may customize your AppBar color as needed
              ),
              body: CustomScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(article, context),
                  _buildAuthorRow(article, user),
                  const SliverToBoxAdapter(child: Divider(thickness: 2)),
                  _buildArticleBrief(article),
                  _buildArticleBody(article, context),
                  const SliverToBoxAdapter(child: Divider(thickness: 2)),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }

  SliverAppBar _buildSliverAppBar(article, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      automaticallyImplyLeading: false, // Removes the back arrow
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 16), // Adjust title padding as needed
        title: Text(
          article.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black.withOpacity(0.7),
              ),
            ],
          ),
        ),
        background: Image.network(
          article.bannerImage.toString(),
          errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/onboarding1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  SliverToBoxAdapter _buildAuthorRow(article, user) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture),
              radius: 24, // Adjust the size as needed
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(article.postedOn.toDate()),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildArticleBrief(article) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          article.brief.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildArticleBody(article, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          article.body.toString(),
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart' as provider;
// import '../../../../../core/common/error_text.dart';
// import '../../../../../core/common/loader.dart';
// import '../../../../../theme/app_colors.dart';
// import '../../../../../theme/theme_provider.dart';
// import '../../../../user/controller/user_controller.dart';
// import '../../../controller/feed_controller.dart';
//
// class ArticleScreen extends ConsumerStatefulWidget {
//   final String? articleId;
//   const ArticleScreen({required this.articleId, super.key});
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
// }
//
// class _ArticleScreenState extends ConsumerState<ArticleScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = provider.Provider.of<ThemeProvider>(context);
//     bool isDarkTheme = themeProvider.isDark;
//
//     return ref.watch(getArticleByIdProvider(widget.articleId!)).when(
//       data: (article) {
//         return ref.watch(getUserDataByIdProvider(article.author.toString())).when(
//           data: (user) {
//             return Scaffold(
//               appBar: AppBar(),
//               body: CustomScrollView(
//                 scrollDirection: Axis.vertical,
//                 physics: const BouncingScrollPhysics(),
//                 controller: ScrollController(initialScrollOffset: 0),
//                 slivers: [
//                   _buildSliverAppBar(article, context),
//                   _buildAuthorRow(article, user),
//                   const SliverToBoxAdapter(child: Divider(thickness: 2)),
//                   _buildArticleBrief(article),
//                   _buildArticleBody(article, context),
//                   const SliverToBoxAdapter(child: Divider(thickness: 2)),
//                 ],
//               ),
//             );
//           },
//           error: (error, stackTrace) => ErrorText(error: error.toString()),
//           loading: () => const Loader(),
//         );
//       },
//       error: (error, stackTrace) => ErrorText(error: error.toString()),
//       loading: () => const Loader(),
//     );
//   }
//
//   SliverAppBar _buildSliverAppBar(article, BuildContext context) {
//     return SliverAppBar(
//       toolbarHeight: 80,
//       expandedHeight: 300,
//       pinned: true,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Image.network(
//           article.bannerImage.toString(),
//           errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/onboarding1.jpg'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(25),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.only(top: 5, bottom: 10),
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(35),
//               topRight: Radius.circular(35),
//             ),
//           ),
//           child: Center(
//             child: SelectableText(
//               article.title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     );
//   }
//
//   SliverToBoxAdapter _buildAuthorRow(article, user) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: NetworkImage(user.profilePicture),
//             ),
//             const SizedBox(width: 18),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 Row(
//                   children: [
//                     Text(DateFormat('MMM dd, yyyy').format(article.postedOn.toDate()), style: const TextStyle(fontWeight: FontWeight.w400)),
//                     const SizedBox(width: 5),
//                     Text('${article.postLength.toString()}min read', style: const TextStyle(fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   SliverToBoxAdapter _buildArticleBrief(article) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Text(
//           article.brief.toString(),
//           style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
//           textAlign: TextAlign.justify,
//         ),
//       ),
//     );
//   }
//
//   SliverToBoxAdapter _buildArticleBody(article, BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(8).copyWith(top: 20),
//         child: Text(
//           article.body.toString(),
//           style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 18),
//           textAlign: TextAlign.justify,
//         ),
//       ),
//     );
//   }
// }
//
//
//
// // import 'package:hackathon_proj/features/user/controller/user_controller.dart';
// // import 'package:intl/intl.dart';
// //
// // /// Import this line
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// //
// // import '../../../../../core/common/error_text.dart';
// // import '../../../../../core/common/loader.dart';
// // import '../../../../../theme/app_colors.dart';
// // import '../../../../../theme/theme_provider.dart';
// // import '../../../controller/feed_controller.dart';
// // import 'package:provider/provider.dart' as provider;
// //
// // class ArticleScreen extends ConsumerStatefulWidget {
// //   final String? articleId;
// //   const ArticleScreen({required this.articleId, super.key});
// //
// //   @override
// //   ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
// // }
// //
// // class _ArticleScreenState extends ConsumerState<ArticleScreen> {
// //   // final commentController = TextEditingController();
// //
// //   // @override
// //   // void dispose() {
// //   //   super.dispose();
// //   //   commentController.dispose();
// //   // }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final themeProvider = provider.Provider.of<ThemeProvider>(context);
// //     bool isDarkTheme = themeProvider.isDark;
// //     return ref.watch(getArticleByIdProvider(widget.articleId!)).when(
// //           data: (article) {
// //             return ref
// //                 .watch(getUserDataByIdProvider(article.author.toString()))
// //                 .when(
// //                   data: (user) {
// //                     print('article Screen is calling in user ref');
// //                     return Scaffold(
// //                         appBar: AppBar(
// //
// //                     ),
// //                       body: CustomScrollView(
// //                         scrollDirection: Axis.vertical,
// //                         physics: const BouncingScrollPhysics(),
// //                         controller: ScrollController(initialScrollOffset: 0),
// //                         shrinkWrap: true,
// //                         slivers: [
// //                           SliverAppBar(
// //                             toolbarHeight: 80,
// //                             bottom: PreferredSize(
// //                               preferredSize: const Size.fromHeight(25),
// //                               child: Container(
// //                                 width: double.maxFinite,
// //                                 padding:
// //                                     const EdgeInsets.only(top: 5, bottom: 10),
// //                                 decoration:  BoxDecoration(
// //                                   color:Theme.of(context).primaryColor,
// //                                   borderRadius: BorderRadius.only(
// //                                     topRight: Radius.circular(35),
// //                                     topLeft: Radius.circular(35),
// //                                   ),
// //                                 ),
// //                                 child: Center(
// //                                   child: SelectableText(
// //                                     article.title,
// //                                     textAlign: TextAlign.center,
// //                                     style: const TextStyle(
// //                                         color: Colors.white,
// //                                         fontSize: 25,
// //                                         fontWeight: FontWeight.bold),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             pinned: true,
// //                             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //                             expandedHeight: 300,
// //                             flexibleSpace: Padding(
// //                               padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 20,right: 20),
// //                               child: FlexibleSpaceBar(
// //                                 background: Image.network(
// //                                   article.bannerImage.toString(),
// //                                   errorBuilder: (context, error, stackTrace) =>
// //                                       Image.asset('assets/images/onboardin1.jpg'),
// //                                   width: double.maxFinite,
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           SliverToBoxAdapter(
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Row(
// //                                 mainAxisAlignment: MainAxisAlignment.start,
// //                                 children: [
// //                                   CircleAvatar(
// //                                     backgroundImage:
// //                                         NetworkImage(user.profilePicture),
// //                                   ),
// //                                   const SizedBox(
// //                                     width: 18,
// //                                   ),
// //                                   Column(
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     children: [
// //                                       Text(
// //                                         user.name,
// //                                         style: const TextStyle(
// //                                           fontSize: 20,
// //                                             fontWeight: FontWeight.bold
// //                                         ),
// //                                       ),
// //                                       Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.start,
// //                                         children: [
// //                                           Text(
// //                                             DateFormat('MMM dd, yyyy').format(
// //                                                 article.postedOn.toDate()),
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.w400,
// //                                                 ),
// //                                           ),
// //                                           SizedBox(
// //                                             width: 5,
// //                                           ),
// //                                           Text(
// //                                             '${article.postLength.toString()}min required to read',
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.w500,
// //                                                 ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                           const SliverToBoxAdapter(
// //                             child: Padding(
// //                               padding: EdgeInsets.all(4.0),
// //                               child: Divider(
// //                                 thickness: 4,
// //                               ),
// //                             ),
// //                           ),
// //                           SliverToBoxAdapter(
// //                             child: Container(
// //                               padding: const EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 borderRadius: BorderRadius.circular(50),
// //                               ),
// //                               child: Center(
// //                                 child: Text(
// //                                   article.brief.toString(),
// //                                   style: const TextStyle(
// //                                     fontWeight: FontWeight.w500,
// //                                     fontSize: 20
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           SliverToBoxAdapter(
// //                             child: Padding(
// //                               padding:
// //                                   const EdgeInsets.all(8).copyWith(top: 20),
// //                               child: Text(
// //                                 article.body.toString(),
// //                                 style:Theme.of(context).textTheme.titleSmall,
// //                               ),
// //                             ),
// //                           ),
// //                           const SliverToBoxAdapter(
// //                             child: Padding(
// //                               padding: EdgeInsets.only(left: 6, right: 6),
// //                               child: Divider(
// //                                 thickness: 4,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   },
// //                   error: (error, stackTrace) =>
// //                       ErrorText(error: error.toString()),
// //                   loading: () => const Loader(),
// //                 );
// //           },
// //           error: (error, stackTrace) {
// //             return ErrorText(error: error.toString());
// //           },
// //           loading: () => const Loader(),
// //         );
// //   }
// // }
