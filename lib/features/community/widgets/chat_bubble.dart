import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/features/user/controller/user_controller.dart';
import 'package:hackathon_proj/theme/app_colors.dart';
import 'package:provider/provider.dart' as provider;

import '../../../theme/theme_provider.dart';

class Bubble extends ConsumerWidget {
  final bool isMe;
  final String message;
  final String sender;

  const Bubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.isDark;

    return ref.watch(getUserDataByIdProvider(sender)).when(
      data: (user) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // User name text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold, // bold text for user name
                  ),
                ),
              ),
              // Message row
              Row(
                mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  // Conditional to display the avatar on the left for other user's messages
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundColor: isDarkTheme ? Dcream :Lpurple1,
                        backgroundImage: NetworkImage(user.profilePicture), // user profile image
                        radius: 20, // adjust the size of avatar
                      ),
                    ),
                  // Message bubble
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 2.0),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      decoration: BoxDecoration(
                        color: isMe
                            ? isDarkTheme ? userBubble : Lpurple3
                            : isDarkTheme ? botBubble : Lpurple2,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: isMe ? Radius.circular(16) : Radius.circular(0),
                          bottomRight: isMe ? Radius.circular(0) : Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Conditional to display the avatar on the right for user's own messages
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePicture), // user profile image
                        radius: 20, // adjust the size of avatar
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => CircularProgressIndicator(),
    );
  }
}
