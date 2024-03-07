import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart' as provider;
import '../../../theme/theme_provider.dart';
import '../../theme/app_colors.dart';



class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  FlutterTts flutterTts = FlutterTts();
  String _lastSpokenText = '';
  Future<void> pauseSpeech() async {
    await flutterTts.pause();
  }

  Future<void> continueSpeech(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stopSpeech() async {
    await flutterTts.stop();
  }


  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();


  bool _isRecording = false;

  RecorderStream _recorder = RecorderStream();
  late StreamSubscription _recorderStatus;
  late StreamSubscription<List<int>> _audioStreamSubscription;
  late BehaviorSubject<List<int>> _audioStream;
  late DialogflowGrpcV2Beta1 dialogflow;
  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _audioStreamSubscription?.cancel();
    super.dispose();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([
      _recorder.initialize()
    ]);




    // Get a Service account
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/credentials.json'))}');
    // Create a DialogflowGrpc Instance
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);

  }

  void stopStream() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
  }

  void handleSubmitted(text) async {
    print(text);
    _textController.clear();

    //TODO Dialogflow Code
    ChatMessage message = ChatMessage(
      text: text,
      name: "You",
      type: true,
    );

    setState(() {
      _messages.insert(0, message);
    });

    DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');
    String fulfillmentText = data.queryResult.fulfillmentText;
    if(fulfillmentText.isNotEmpty) {
      ChatMessage botMessage = ChatMessage(
        text: fulfillmentText,
        name: "Bot",
        type: false,
        onSpeak: () => continueSpeech(fulfillmentText),
        onPause: () => pauseSpeech(),
        onStop: () => stopSpeech(),
      );

      setState(() {
        _messages.insert(0, botMessage);
      });

      await flutterTts.speak(fulfillmentText);
    }
  }

  void handleStream() async {
    _recorder.start();

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((data) {
      print(data);
      _audioStream.add(data);
    });


    // TODO Create SpeechContexts
    // Create an audio InputConfig
    var biasList = SpeechContextV2Beta1(
        phrases: [
          'Dialogflow CX',
          'Dialogflow Essentials',
          'Action Builder',
          'HIPAA'
        ],
        boost: 20.0
    );

    // See: https://cloud.google.com/dialogflow/es/docs/reference/rpc/google.cloud.dialogflow.v2#google.cloud.dialogflow.v2.InputAudioConfig
    var config = InputConfigV2beta1(
        encoding: 'AUDIO_ENCODING_LINEAR_16',
        languageCode: 'en-US',
        sampleRateHertz: 16000,
        singleUtterance: false,
        speechContexts: [biasList]
    );

    final responseStream = dialogflow.streamingDetectIntent(config, _audioStream);
// Get the transcript and detectedIntent and show on screen
    responseStream.listen((data) {
      //print('----');
      setState(() {
        //print(data);
        String transcript = data.recognitionResult.transcript;
        String queryText = data.queryResult.queryText;
        String fulfillmentText = data.queryResult.fulfillmentText;

        if(fulfillmentText.isNotEmpty) {

          ChatMessage message = new ChatMessage(
            text: queryText,
            name: "You",
            type: true,
          );

          ChatMessage botMessage = new ChatMessage(
            text: fulfillmentText,
            name: "Bot",
            type: false,
            onSpeak: () => continueSpeech(fulfillmentText),
            onPause: () => pauseSpeech(),
            onStop: () => stopSpeech(),
          );

          _messages.insert(0, message);
          _textController.clear();
          _messages.insert(0, botMessage);
          flutterTts.speak(fulfillmentText);

        }
        if(transcript.isNotEmpty) {
          _textController.text = transcript;

        }

      });
    },onError: (e){
      //print(e);
    },onDone: () {
      //print('done');
    });
    // TODO Make the streamingDetectIntent call, with the InputConfig and the audioStream
    // TODO Get the transcript and detectedIntent and show on screen

  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bot Support",
          style: TextStyle(
            fontSize: 24,
            color: isDarkTheme ? Colors.white : Lcream,
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )),

          Container(
            decoration: BoxDecoration(
              // color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                width: 3,
                color: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
              ),



            ),
            child: IconTheme(
              data: IconThemeData(
                // color: Colors.black
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Flexible(

                      child: TextField(
                        controller: _textController,
                        onSubmitted: handleSubmitted,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(

                          hintText: "Send a message",
                          // border: InputBorder.none
                          // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),

                          // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),

                          border: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide:  BorderSide(width: 0, color: Theme.of(context).scaffoldBackgroundColor),
                          ),
                          enabledBorder: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide:  BorderSide(width: 0, color: Theme.of(context).scaffoldBackgroundColor),
                          ),
                          focusedBorder: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide:  BorderSide(width: 0, color: Theme.of(context).scaffoldBackgroundColor),
                          ),
                          errorBorder: const OutlineInputBorder().copyWith(
                            // borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide:  BorderSide(width: 0, color: Theme.of(context).scaffoldBackgroundColor),
                          ),
                          focusedErrorBorder: const OutlineInputBorder().copyWith(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide:  BorderSide(width: 0, color: Theme.of(context).scaffoldBackgroundColor),
                          ),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                          color: isDarkTheme ? Dcream : Theme.of(context).primaryColor,  // Red background color
                          shape: BoxShape.circle, // Circular shape
                        ),
                        child: IconButton(
                          iconSize: 22.0,
                          icon: Icon(Icons.send,
                            color: isDarkTheme ? Dbrown1 : Lcream,
                          ),
                          onPressed: () => handleSubmitted(_textController.text),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                          color: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
                          shape: BoxShape.circle, // Circular shape
                        ),
                        child: IconButton(
                          color: isDarkTheme ? Dbrown1 : Lcream,
                          iconSize: 24.0,
                          icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
                          onPressed: _isRecording ? stopStream : handleStream,
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),

          ),
        ]),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {

  const ChatMessage({
    super.key,
    required this.text,
    required this.name,
    required this.type,
    this.onSpeak,
    this.onPause,
    this.onStop,
  });

  final String text;
  final String name;
  final bool type;
  final VoidCallback? onSpeak;
  final VoidCallback? onPause;
  final VoidCallback? onStop;
  List<Widget> otherMessage(context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    var w = MediaQuery.of(context).size.width;

    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right:7.0),
        child: CircleAvatar(
            backgroundColor: isDarkTheme ? botBubble : Lpurple3,
            child: new Text('B',
              style: TextStyle(
                color:isDarkTheme ? Colors.white: Colors.black,
              ),
            )),
      ),
      new Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    20,
                  ),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(0),
                ),
                color: isDarkTheme ? botBubble : Lpurple3,
              ),
              margin: const EdgeInsets.only(top: 1.0,bottom: 5),
              child: Text(text),
            ),
            if (!type) Row( // Add this check to show controls only for bot messages
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (onPause != null)
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: isDarkTheme ? Dcream : Theme.of(context).primaryColor, // Background color
                      shape: BoxShape.circle, // Circular shape
                    ),
                    margin: EdgeInsets.all(4), // Space around the button
                    child: IconButton(
                      icon: Icon(Icons.pause,
                        color: isDarkTheme ? Dbrown1 : Lcream,
                        size: 15,), // Icon color
                      onPressed: onPause,
                    ),
                  ),
                if (onSpeak != null)
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color:  isDarkTheme ? Dcream : Theme.of(context).primaryColor,
                      shape: BoxShape.circle, // Circular shape
                    ),
                    margin: EdgeInsets.all(4), // Space around the button
                    child: IconButton(
                      icon: Icon(Icons.play_arrow,
                        color: isDarkTheme ? Dbrown1 : Lcream,
                        size: 15,), // Icon color
                      onPressed: onSpeak,
                    ),
                  ),

                if (onStop != null)
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: isDarkTheme ? Dcream : Theme.of(context).primaryColor, // Background color
                      shape: BoxShape.circle, // Circular shape
                    ),
                    margin: EdgeInsets.all(4), // Space around the button
                    child: IconButton(
                      icon: Icon(Icons.stop,
                        color: isDarkTheme ? Dbrown1 : Lcream,
                        size: 15,), // Icon color
                      onPressed: onStop,
                    ),
                  ),
                //   if (onPause != null) IconButton(icon: Icon(Icons.pause), onPressed: onPause),
                // if (onSpeak != null) IconButton(
                //     icon: Icon(Icons.play_arrow), onPressed: onSpeak,),
                //
                // if (onStop != null) IconButton(icon: Icon(Icons.stop), onPressed: onStop),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name, style: Theme.of(context).textTheme.subtitle1),
            Container(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    20,
                  ),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: isDarkTheme ? userBubble : Lpurple2,
              ),
              margin: const EdgeInsets.only(top: 1.0),
              child: Text(text),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 7.0),
        child: CircleAvatar(
            backgroundColor: isDarkTheme ? userBubble : Lpurple2,
            child: Text(
              this.name[0],
              style: TextStyle(fontWeight: FontWeight.bold,
                color:isDarkTheme ? Colors.white: Colors.black,),
            )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}