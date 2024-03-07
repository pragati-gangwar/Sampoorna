import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as provider;

import '../../theme/app_colors.dart';
import '../../theme/theme_provider.dart';

const apiKey = "AIzaSyAPmdlw5gWgBTySR-N-gWyqBOab39Nx6J4";

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "ChatBot Support",
                style: TextStyle(
                  fontSize: 24,
                  color: isDarkTheme ? Colors.white : Lcream,
                ),
              ),
              centerTitle: true,
              bottom: TabBar(
                // Custom color for selected tab text
                labelColor: isDarkTheme ? Dcream : Colors.black, // Set your desired color for selected tab text
                // Custom color for unselected tab text
                unselectedLabelColor:  isDarkTheme ? Colors.white : Lcream, // Set your desired color for unselected tab text
                labelStyle: TextStyle(
                  fontSize: 22, // Set your desired font size for selected tab text
                  fontWeight: FontWeight.bold, // Set your desired font weight for selected tab text
                ),
                // Custom style for unselected tab text
                unselectedLabelStyle: TextStyle(
                  fontSize: 20, // Set your desired font size for unselected tab text
                  fontWeight: FontWeight.w400, // Set your desired font weight for unselected tab text
                ),
                // Custom indicator as a bottom border
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: isDarkTheme ? Dcream : Colors.black,// Set your desired color for the bottom border
                    width: 4.0, // Set your desired width for the bottom border
                  ),

                ),
                tabs: [
                  Tab(
                    text: "Text Only",
                  ),
                  Tab(text: "Text with Image"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [TextOnly(), TextWithImage()],
            )));
  }
}

// ------------------------------ Text Only ------------------------------

class TextOnly extends StatefulWidget {
  const TextOnly({
    super.key,
  });

  @override
  State<TextOnly> createState() => _TextOnlyState();
}

class _TextOnlyState extends State<TextOnly> {
  bool loading = false;
  List textChat = [];
  List textWithImageChat = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  // Text only input
  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": "User",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": value.text,
        });
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: textChat.length,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) {
                  return ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      backgroundColor: isDarkTheme ? userBubble : Lpurple2,
                      child: Text(textChat[index]["role"].substring(0, 1),
                        style: TextStyle(fontWeight: FontWeight.bold,
                          color:isDarkTheme ? Colors.white: Colors.black,),
                      ),),
                    title: Text(textChat[index]["role"]),
                    subtitle: Text(textChat[index]["text"]),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.only(left: 15.0, right: 7),
              decoration: BoxDecoration(
                // color: Colors.white, // Background color of the container
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  width: 3,
                  color: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: const OutlineInputBorder().copyWith(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                              width: 0,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        enabledBorder: const OutlineInputBorder().copyWith(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                              width: 0,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        focusedBorder: const OutlineInputBorder().copyWith(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                              width: 0,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        errorBorder: const OutlineInputBorder().copyWith(
                          // borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                              width: 0,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        focusedErrorBorder: const OutlineInputBorder().copyWith(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                              width: 0,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? Dcream
                          : Theme.of(context).primaryColor, // Red background color
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: IconButton(
                      icon: loading
                          ? const CircularProgressIndicator()
                          : Icon(
                        Icons.send,
                        color: isDarkTheme ? Dbrown1 : Lcream,
                      ),
                      onPressed: () {
                        fromText(query: _textController.text);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

// ------------------------------ Text with Image ------------------------------

class TextWithImage extends StatefulWidget {
  const TextWithImage({
    super.key,
  });

  @override
  State<TextWithImage> createState() => _TextWithImageState();
}

class _TextWithImageState extends State<TextWithImage> {
  bool loading = false;
  List textAndImageChat = [];
  List textWithImageChat = [];
  File? imageFile;

  final ImagePicker picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  // Text only input
  void fromTextAndImage({required String query, required File image}) {
    setState(() {
      loading = true;
      textAndImageChat.add({
        "role": "User",
        "text": query,
        "image": image,
      });
      _textController.clear();
      imageFile = null;
    });
    scrollToTheEnd();

    gemini.generateFromTextAndImages(query: query, image: image).then((value) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Gemini", "text": value.text, "image": ""});
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Gemini", "text": error.toString(), "image": ""});
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: textAndImageChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundColor: isDarkTheme ? userBubble : Lpurple2,
                    child: Text(
                      textAndImageChat[index]["role"].substring(0, 1),
                      style: TextStyle(fontWeight: FontWeight.bold,
                        color:isDarkTheme ? Colors.white: Colors.black,),

                    ),
                  ),
                  title: Text(textAndImageChat[index]["role"]),
                  subtitle: Text(textAndImageChat[index]["text"]),
                  trailing: textAndImageChat[index]["image"] == ""
                      ? null
                      : Image.file(
                    textAndImageChat[index]["image"],
                    width: 90,
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(left: 15.0, right: 4),
            decoration: BoxDecoration(
              // color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                width: 3,
                color: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Write a message",
                      border: const OutlineInputBorder().copyWith(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                            width: 0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                      enabledBorder: const OutlineInputBorder().copyWith(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                            width: 0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                      focusedBorder: const OutlineInputBorder().copyWith(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                            width: 0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                      errorBorder: const OutlineInputBorder().copyWith(
                        // borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                            width: 0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                      focusedErrorBorder: const OutlineInputBorder().copyWith(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                            width: 0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: isDarkTheme
                        ? Dcream
                        : Theme.of(context)
                        .primaryColor, // Red background color
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: isDarkTheme ? Dbrown1 : Lcream,
                    ),
                    onPressed: () async {
                      final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imageFile = image != null ? File(image.path) : null;
                      });
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: isDarkTheme
                        ? Dcream
                        : Theme.of(context)
                        .primaryColor, // Red background color
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    icon: loading
                        ? const CircularProgressIndicator()
                        : Icon(
                      Icons.send,
                      color: isDarkTheme ? Dbrown1 : Lcream,
                    ),
                    onPressed: () {
                      if (imageFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select an image")));
                        return;
                      }
                      fromTextAndImage(
                          query: _textController.text, image: imageFile!);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: imageFile != null
          ? Container(
        margin: const EdgeInsets.only(bottom: 80),
        height: 150,
        child: Image.file(imageFile ?? File("")),
      )
          : null,
    );
  }
}