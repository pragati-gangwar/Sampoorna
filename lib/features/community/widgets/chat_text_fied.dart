
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;
class ChatTextFieldBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;
  final bool isListening;
  const ChatTextFieldBar({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onMic,
    required this.isListening,
  }) : super(key: key);

  @override
  State<ChatTextFieldBar> createState() => _ChatTextFieldBarState();
}

class _ChatTextFieldBarState extends State<ChatTextFieldBar> {
  @override
  Widget build(BuildContext context) {
    bool showSendButton = widget.controller.text.isNotEmpty;
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 4),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkTheme ? Dcream : Lpurple1,
              ),
              child: IconButton(
                onPressed: widget.onMic,
                icon: Icon(widget.isListening ? Icons.stop : Icons.mic,
                  color: isDarkTheme ? Colors.black : Lcream,),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              onChanged: (val) {
                setState(() {
                  showSendButton = val.trim().isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              maxLines: null, // Allows the input to expand
              minLines: 1, // Initial size of 1 line
              decoration: const InputDecoration(
                hintText: 'Enter Message',
                border: InputBorder.none,
              ),
            ),
          ),
          if (showSendButton)
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkTheme ? Dcream : Lpurple1,
                ),
                child: IconButton(
                  onPressed: () {
                    widget.onSend();
                  },
                  icon:  Icon(
                    Icons.send,
                    color: isDarkTheme ? Colors.black : Lcream,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
