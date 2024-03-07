import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/routes/route_utils.dart';
import 'package:hackathon_proj/theme/app_colors.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../theme/font_provider.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/community_controller.dart';
import '../deligates/search.dart';
import 'package:provider/provider.dart' as provider;

class CommunityHome extends ConsumerStatefulWidget {
  const CommunityHome({super.key});

  @override
  ConsumerState<CommunityHome> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends ConsumerState<CommunityHome> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user = ref.watch(userProvider)!;
    final fontsize = ref.watch(fontSizesProvider);

    return Scaffold(
      appBar: AppBar(
        title:  Text('Communities',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 24,
            color: isDarkTheme ? Colors.white : Lcream,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigation.navigateSearchCommunity(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final community = communities[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          margin: EdgeInsets.all(0.3),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                community.groupIcon,
                              ),
                              radius: 28,
                            ),
                            title: Text(
                              community.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    fontSize: fontsize.subheadingSize + 4,
                                  ),
                            ),
                            subtitle: Text(
                              community.recentMessage,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: fontsize.fontSize),
                            ),
                            onTap: () {
                              Navigation.navigateCommunity(context, community.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigation.navigateCreateCommunity(context);
        },
        backgroundColor: isDarkTheme ? Dcream : Lpurple1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add,
        color: isDarkTheme ? Colors.black : Colors.white,),

      ),
    );
  }
}
