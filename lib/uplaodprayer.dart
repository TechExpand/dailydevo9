import 'dart:io';
import 'package:dailydevo9/Firebase_service.dart';
import 'package:dailydevo9/utils.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class UploadPrayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final form_key = GlobalKey<FormState>();
    var title;
    var dailydevo;


    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Prayer', style: TextStyle(color: Colors.white),),
        elevation: 10,
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Center(child: Padding(
            padding: const EdgeInsets.only(left:3.0),
            child: Text('Cancel', style: TextStyle(fontSize: 17,color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.fade,),
          )),
        ),
        backgroundColor: Colors.brown,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top:30),
          child: Center(
              child: Consumer<Utils>(
                  builder: (context, webservices_consumer, child) {
                    return Form(
                      key: form_key,
                      child: Column(
                        children: <Widget>[

                          Container(
                            padding: EdgeInsets.only( bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'title Required';
                                  } else {
                                    title = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Title',
                                  hintText: 'Great God',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:10, bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'prayer required';
                                  } else {
                                    dailydevo = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Prayer',
                                  hintText: 'All things work together for our good',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                )
                            ),
                          ),





                          Padding(
                              padding:  EdgeInsets.only(top: 30, bottom: 50),
                              child: Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 25,
                                  child:   webservices_consumer.isLoading == false?FlatButton(
                                    onPressed: (){
                                      if(form_key.currentState.validate()){
                                        // webservices_consumer.setLoading(true);
                                        FirebaseApi.uploadprayer(
                                          title: title,
                                          body: dailydevo,
                                        ).then((value) {
                                          Navigator.pop(context);
                                        }) ;
                                      }
                                    },
                                    color:Colors.brown,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24)
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: 190.0, minHeight: 53.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                            "UPLOAD",
                                            textAlign: TextAlign.center,
                                            style:TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                                        ),
                                      ),
                                    ),

                                  ):Text('Uploading...')
                              )
                          )


                        ],
                      ),
                    );
                  })
          ),
        ),
      ),
    );
  }
}
