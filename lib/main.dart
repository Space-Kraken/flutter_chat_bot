import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final msgController = TextEditingController();
  List<Map> msgs = [];
  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/service.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    setState(() {
      msgs.insert(0, {
        // "data": DateFormat('kk:mm').format(DateTime.now()),
        'data': 0,
        'message': response.getListMessage()[0]['text']['text'][0].toString(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chatbot"),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text("Today, ${DateFormat("Hm").format(DateTime.now())}", style: TextStyle(fontSize: 20),),
              ),
            ),

            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: msgs.length,
                itemBuilder: (context, index) => chat(
                  msgs[index]['message'].toString(), 
                  msgs[index]['data'],  
                ),
              )
            ),

            const Divider(
              height: 5,
              color: Colors.greenAccent,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                child: ListTile(
                  title: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromRGBO(220, 220, 220, 1)
                    ),
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: msgController,
                      decoration: const InputDecoration(
                        hintText: "Type your message here",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black
                      ),
                    ),
                  ),
                  trailing: IconButton( 
                    icon: const Icon(Icons.send),
                    iconSize: 30,
                    color: Colors.greenAccent,
                    onPressed: (){
                      if(msgController.text.isEmpty){
                        print("Empty");
                      }else{
                        setState(() {  
                          msgs.insert(0, {
                            "data":1,
                            "message": msgController.text,
                          });
                        });
                        response(msgController.text);
                        msgController.clear();
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if(!currentFocus.hasPrimaryFocus){
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget chat(String msg, int data){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: data == 1 ? MainAxisAlignment.end: MainAxisAlignment.start,
        children: [
          data == 0 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/bot.png"),
            ),
          ): Container(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Bubble(
              radius: const Radius.circular(15),
              color: data == 0 ? const Color.fromRGBO(23, 157, 139, 1): Colors.orangeAccent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          msg,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      )
                    )
                  ],
                ),
              ),
            ),
          ),

          data == 1 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/user.png"),
            ),
          ): Container(), 
        ],
      ),
    );
  }
}

