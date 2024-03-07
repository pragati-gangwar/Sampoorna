import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/features/community/controller/community_controller.dart';
import 'package:hackathon_proj/features/community/views/list_of_members.dart';
import 'package:hackathon_proj/theme/app_colors.dart';
import 'package:hackathon_proj/theme/font_provider.dart';
import 'package:provider/provider.dart' as provider;
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/community_model.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_text_fied.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class CommunityChatScreen extends ConsumerStatefulWidget {
  final String id;
  const CommunityChatScreen({super.key, required this.id});

  @override
  CommunityChatScreenState createState() => CommunityChatScreenState();
}

class CommunityChatScreenState extends ConsumerState<CommunityChatScreen> {
  ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  late FocusNode _focusNode;
  final speechToText = SpeechToText();
  String lastWords = '';

  void sendMessage() {
    ref.read(communityControllerProvider.notifier).sendTextMessage(
      text: messageController.text.trim(),
      communityId: widget.id,
      context: context,
    );
    messageController.clear();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      messageController.text = result.recognizedWords;
    });
  }

  void leaveCommunity(Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
    Navigation.navigateToBack(context);
  }

  @override
  void initState() {
    messageController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    initSpeechToText();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    speechToText.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = ref.watch(fontSizesProvider);
    print(messageController.text);
    final user = ref.watch(userProvider)!;
    return ref.watch(getCommunityByIdProvider(widget.id)).when(
      data: (community) {
        final themeProvider = provider.Provider.of<ThemeProvider>(context);
        bool isDarkTheme = themeProvider.isDark;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: [
              community.admin != user.id
                  ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkTheme ? Dcream : Lpurple3,
                                    ),
                      child: IconButton(
                                      onPressed: () {
                      leaveCommunity(community);
                                      },
                                      icon: const Icon(Icons.logout,
                                      size: 18,
                                      color: Colors.black,),
                                    ),
                    ),
                  )
                  : const SizedBox(),
            ],
            elevation: 0.4,
            title: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) =>
                      CommunityMembersScreen(id: community.id)),
                ),
              ),
              child: Text(
                community.name,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 24,
                    color: isDarkTheme ? Colors.white : Lcream,
                  ),
                ),
              ),
            ),

          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  reverse: true,
                  child: Column(
                    children: ref
                        .watch(getCommunityMessagesProvider(widget.id))
                        .when(
                      data: (messages) {
                        return messages
                            .map(
                              (message) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Bubble(
                              message: message.text,
                              isMe: message.senderId == user.id,
                              sender: message.senderId,
                            ),
                          ),
                        )
                            .toList();
                      },
                      error: (error, stackTrace) => [
                        ErrorText(
                          error: error.toString(),
                        ),
                      ],
                      loading: () => [const Loader()],
                    ),
                  ),
                ),
              ),
              ChatTextFieldBar(
                controller: messageController,
                onSend: sendMessage,
                onMic: () async {
                  if (await speechToText.hasPermission &&
                      speechToText.isNotListening) {
                    await startListening();
                  } else if (speechToText.isListening) {
                    await stopListening();
                  } else {
                    initSpeechToText();
                  }
                },
                isListening: speechToText.isListening ? true : false,
              )
            ],
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