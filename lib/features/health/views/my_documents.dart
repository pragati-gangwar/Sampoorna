import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/features/health/controller/health_controlller.dart';
import 'package:hackathon_proj/routes/route_utils.dart';
import 'package:hackathon_proj/theme/font_provider.dart';
import 'package:provider/provider.dart' as provider;
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/controller/auth_controller.dart';

class MyDocumentView extends ConsumerStatefulWidget {
  const MyDocumentView({super.key});

  @override
  ConsumerState<MyDocumentView> createState() => _MyDocumentViewState();
}

class _MyDocumentViewState extends ConsumerState<MyDocumentView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user = ref.watch(userProvider)!;
    final fontsize = ref.watch(fontSizesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Documents',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: fontsize.headingSize,
            color: isDarkTheme ? Colors.white : Lcream,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigation.navigateSearchDocument(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ref.watch(userDocumentsProvider).when(
              data: (communities) => Expanded(
                child: ListView.builder(
                  itemCount: communities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = communities[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            document.document,
                          ),
                          radius: 24,
                        ),
                        title: Text(
                          'Title: ${document.title}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                            fontSize: fontsize.subheadingSize + 4,
                          ),
                        ),
                        trailing: Container(
                    // height: 200, // Fixed height for the container
                    decoration: BoxDecoration(
                    color:isDarkTheme ? Dcream : Theme.of(context).primaryColor, // Background color
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    border: Border.all(
                    color: Theme.of(context).primaryColor, // Border color
                    width: 1, // Border width
                    ),),
                          child: TextButton(
                            onPressed: () {
                              Navigation.navigateDocument(context, document.id);
                            }, child: Text("Open",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: fontsize.fontSize,
                            color: Colors.black),
                          ),

                          ),
                        ),
                        subtitle: Text(
                          'About: ${document.description}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: fontsize.fontSize),
                        ),
                        onTap: () {
                          Navigation.navigateDocument(context, document.id);
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
        backgroundColor: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
        onPressed: () {
          Navigation.navigateCreateDocument(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),

        child: const Icon(Icons.add,size: 30,
          color: Colors.black,),
      ),
    );
  }
}