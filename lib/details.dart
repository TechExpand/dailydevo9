import 'package:dailydevo9/utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Details extends StatefulWidget {
  var data;
  Details(this.data);
  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    var date = Utils().formatDate(
        widget.data.lastMessageTime.toDate());
    return Scaffold(
        body: Stack(
          children: [
            Container(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Hero(
                    tag: widget.data.image,
                    child: Container(
                      height:300,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(widget.data.image, fit:  BoxFit.cover,),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.data.title, style: TextStyle(fontSize: 23, color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:4.0, left: 8),
                    child: Text(date, style: TextStyle(fontSize: 13, color: Colors.black54),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:4.0, left: 8),
                    child: Text("Article by DailyDevotional", style: TextStyle(fontSize: 13, color: Colors.black54),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:4.0, left: 8),
                    child: Wrap(
                      children: [
                        Expanded(child: Text(widget.data.body,
                            style: TextStyle(color: Colors.black)
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:30),
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){
                    Navigator.pop(context);
                  }, icon: Container(
                    height: 100,
                    width: 150,
                    child: Material(
                      color: Colors.white,
                        elevation: 9,
                        borderRadius: BorderRadius.circular(100),
                        child: Icon(Icons.arrow_back_ios_sharp, color: Colors.brown,size: 25,)),
                  )),
                  Spacer(),
                  IconButton(
                      onPressed: (){
                        Share.share('${widget.data.body} \n\nFrom DailyDevotional', subject: widget.data.title);
                      }, icon: Container(
                    height: 100,
                        width: 150,
                        child: Material(
                        color: Colors.white,
                        elevation: 9,
                        borderRadius: BorderRadius.circular(100),
                        child: Icon(Icons.share, color: Colors.brown,size: 25,)),
                      )),
                ],
              ),
            )
          ],
        )
    );
  }
}
