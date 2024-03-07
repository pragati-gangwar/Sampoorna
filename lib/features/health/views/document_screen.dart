import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/core/common/error_text.dart';
import 'package:hackathon_proj/features/health/controller/health_controlller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;
import '../../../core/common/loader.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/font_provider.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/controller/auth_controller.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final fontSize = ref.watch(fontSizesProvider);

    return ref.watch(getDocumentByIdProvider(widget.id)).when(
      data: (doc) {
        final themeProvider = provider.Provider.of<ThemeProvider>(context);
        bool isDarkTheme = themeProvider.isDark;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            title: Text(
              doc.title,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: fontSize.headingSize,
                color: isDarkTheme ? Colors.white : Lcream,
              ),
            ),
          ),
          body: ref.watch(getDocumentByIdProvider(widget.id)).when(
            data: (documents) {
              final docDetails = documents;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Display Image
                      if (docDetails.document != null)
                        Image.network(
                          docDetails.document,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Title: ${docDetails.title}',
                        style:
                        TextStyle(fontSize: fontSize.headingSize),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description: ${docDetails.description}',
                        style: TextStyle(
                            fontSize: fontSize.subheadingSize),
                      ),

                      const SizedBox(height: 24),
                      Text(
                        'Created On: ${DateFormat('hh:mm a, MMM dd, yyyy').format(docDetails.createdOn.toDate())}',
                        style: TextStyle(fontSize: fontSize.fontSize),
                      ),
                      const SizedBox(height: 4),
                      // Add more details as needed
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
      loading: () => const Loader(),
    );
  }
}