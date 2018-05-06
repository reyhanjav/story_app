import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(new StryApp());
}

class StryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "stry",
      theme: new ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.indigoAccent[400],
      ),                                        //new
      home: new ChatScreen(),
    );
  }
}

// Modify the ChatScreen class definition to extend StatefulWidget.

class ChatScreen extends StatefulWidget {                     //modified
  @override                                                        //new
  State createState() => new ChatScreenState();                    //new
} 

// Add the ChatScreenState class definition in main.dart.

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;                   //new
  @override                                                        //new
  Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(
        title: new Text("stry"),
        elevation: 0.7,
        actions: <Widget>[
            // action button
            new IconButton(
              icon: new Icon(Icons.directions_car),
              onPressed: () {
              },
            ),
        ],
        ),
        
    body: new Container(                                             //modified
        child: new Column(                                           //modified
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS //new
            ? new BoxDecoration(                                     //new
                border: new Border(                                  //new
                  top: new BorderSide(color: Colors.grey[200]),      //new
                ),                                                   //new
              )                                                      //new
            : null),                                                 //modified
  );
}

@override
void dispose() {                                                   //new
  for (ChatMessage message in _messages)                           //new
    message.animationController.dispose();                         //new
  super.dispose();                                                 //new
}

  
 Widget _buildTextComposer() {
  return new IconTheme(
    data: new IconThemeData(color: Theme.of(context).accentColor),
    child: new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onChanged: (String text) {          //new
                setState(() {                     //new
                  _isComposing = text.length > 0; //new
                });                               //new
              },                                  //new
              onSubmitted: _handleSubmitted,
              decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          new Container(
   margin: new EdgeInsets.symmetric(horizontal: 4.0),
   child:                                            //new
   new IconButton(                                            //modified
       icon: new Icon(Icons.send),
       onPressed: _isComposing ?
           () =>  _handleSubmitted(_textController.text) : null,
       )
   ),
        ],
      ),
    ),
  );
}

void _handleSubmitted(String text) {
  _textController.clear();
  setState(() {                                                    //new
    _isComposing = false;                                          //new
  });                                                              //new
  ChatMessage message = new ChatMessage(
    text: text,
    animationController: new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    ),
  );
  setState(() {
    _messages.insert(0, message);
  });
  message.animationController.forward();
}
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(                                    //new
    sizeFactor: new CurvedAnimation(                              //new
        parent: animationController, curve: Curves.bounceOut),      //new
    axisAlignment: 0.0,                                           //new
    child: new Container(                                    //modified
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
           new Expanded(                                               //new
  child: new Column(                                   //modified
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Text(_name, style: Theme.of(context).textTheme.subhead),
      new Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: new Text(text),
      ),
    ],
  ),
),
          ],
        ),
      )                                                           //new
    );
  }
}

const String _name = "Demn";
