import 'dart:io';
import 'package:dailydevo9/Firebase_service.dart';
import 'package:dailydevo9/utils.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class Upload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final form_key = GlobalKey<FormState>();
    var title;
    var dailydevo;


    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add DailyDevotional', style: TextStyle(color: Colors.white),),
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
                                    return 'daily devotional required';
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
                                  labelText: 'Daily Devotional',
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
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Selected Image',style:TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child:  Provider.of<Utils>(context, listen:true).selectedImage == null
                                ? Center(
                              child: Text('No Image Selected'),
                            )
                                : Image.file(
                              File(Provider.of<Utils>(context, listen:true).selectedImage.path),
                              fit: BoxFit.contain,
                            ),
                          ),

                          Padding(
                              padding:  EdgeInsets.only(top: 50),
                              child: webservices_consumer.isLoading == false
                                  ?Material(
                                borderRadius: BorderRadius.circular(26),
                                elevation: 25,
                                child: FlatButton(
                                  onPressed: () {
                                    // webservices.Login_SetState();
                                    webservices_consumer.selectimage(source:ImageSource.gallery, context: context);
                                  },
                                  color: Colors.white10,
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
                                          "Select Image",
                                          textAlign: TextAlign.center,
                                          style:TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
                                      ),
                                    ),
                                  ),

                                ),
                              ):CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),)
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
                                        FirebaseApi.uploaddaily(
                                         title: title,
                                          body: dailydevo,
                                          file: webservices_consumer.selectedImage,
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
