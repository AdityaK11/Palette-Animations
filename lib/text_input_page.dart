import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInputPage extends StatefulWidget {
  @override
  _TextInputPageState createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {

  bool selected = false;
  FocusNode email = new FocusNode();
  FocusNode phone = new FocusNode();
  FocusNode focus;

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.yellow,
          height: height,
          width: width,
          child: Stack(
            children: [
              AnimatedPositioned(
                top: selected?-height:0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  width: width,
                  height: height*0.4,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              AnimatedPositioned(
                top: 40,
                left: selected?width/4:16,
                curve: Curves.easeInOut,
                child: Container(
                  height: width/2,
                  width: width/2,
                  color: Colors.blueAccent,
                ),
                duration: Duration(milliseconds: 500)
              ),
              AnimatedPositioned(
                top: focus==null
                    ?450
                    :focus==email?height/2-50:450,
                right: focus==null
                    ?16
                    :focus==email?16:width,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selected? focus = null:focus = email;
                      selected = !selected;
                    });
                  },
                    child: inputField(context,"email", "hint",email)
                ),
              ),
              AnimatedPositioned(
                top: focus==null
                    ?550
                    :focus==phone?height/2-50:550,
                right: focus==null
                    ?16
                    :focus==phone?16:width,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 500),
                child: GestureDetector(
                    onTap: (){
                      setState(() {
                        selected? focus = null:focus = phone;
                        selected = !selected;
                      });
                    },
                    child: inputField(context,"phone", "hint",phone)
                ),
              ),
              Positioned(
                right: 16,
                top: 450,
                child: AnimatedOpacity(
                  opacity: selected?1:0,
                  duration: Duration(milliseconds: 300),
                  child: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: (){
                      setState(() {
                        selected = false;
                        focus = null;
                      });
                    },
                  ),
                ),
              ),
              AnimatedPositioned(
                top: 200,
                right: selected?-width/2:40,
                duration: Duration(milliseconds: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chandler Bing"),
                    Text("24 yrs - Male")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget inputField(BuildContext context,String label, String hint, FocusNode focusNode){
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Color(0xFF4B5D6B),
          fontSize: 16
        ),
      ),
      SizedBox(height: 8,),
      Container(
        width: MediaQuery.of(context).size.width-32,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.0, color: Color(0xFFCAD1D7)),
        ),
        child: TextField(
          focusNode: focusNode,
          readOnly: true,
          enabled: false,
          decoration: new InputDecoration.collapsed(
            hintText: hint,
          ),
        )
      ),
    ],
  );
}
