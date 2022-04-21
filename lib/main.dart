import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailydevo9/UserChat.dart';
import 'package:dailydevo9/details.dart';
import 'package:dailydevo9/uplaodprayer.dart';
import 'package:dailydevo9/utils.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Firebase_service.dart';
import 'Upload.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Utils>(
      create: (_) => Utils(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Devotional',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'DAILY DEVOTIONAL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   PageController controller;
  int customIndex = 0;
   List<DailyDevo> dailydevo;

  void initState(){
    super.initState();
    controller = PageController(viewportFraction: 1, initialPage: 0,);
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // floatingActionButton: Row(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.only(right:8.0, left: 8),
      //       child: FloatingActionButton.extended(
      //         label: Text('Upload DailyDevotion'.toUpperCase()),
      //         onPressed: (){
      //           Navigator.push(
      //             context,
      //             PageRouteBuilder(
      //               pageBuilder: (context, animation, secondaryAnimation) {
      //                 return Upload();
      //               },
      //               transitionsBuilder: (context, animation, secondaryAnimation, child){
      //                 return FadeTransition(
      //                   opacity: animation,
      //                   child: child,
      //                 );
      //               },
      //             ),
      //           );
      //         },
      //         tooltip: 'Increment',
      //       ),
      //     ),
      //     // Padding(
      //     //   padding: const EdgeInsets.only(left:8.0),
      //     //   child: FloatingActionButton.extended(
      //     //     label: Text('WeeklyPrayer'),
      //     //     onPressed: (){
      //     //       Navigator.push(
      //     //         context,
      //     //         PageRouteBuilder(
      //     //           pageBuilder: (context, animation, secondaryAnimation) {
      //     //             return UploadPrayer();
      //     //           },
      //     //           transitionsBuilder: (context, animation, secondaryAnimation, child){
      //     //             return FadeTransition(
      //     //               opacity: animation,
      //     //               child: child,
      //     //             );
      //     //           },
      //     //         ),
      //     //       );
      //     //     },
      //     //     tooltip: 'Increment',
      //     //   ),
      //     // ),
      //   ],
      // ), // This trailing comma makes auto-formatting nicer for build methods.

      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  StreamBuilder(
        stream:
        FirebaseApi.getDaily(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            dailydevo = snapshot.data.docs
                .map((doc) => DailyDevo.fromMap(doc.data(), doc.id))
                .toList();
            List<DailyDevo> dailyData = [];
            for (var v in dailydevo) {
              dailyData.add(v);
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: Theme(
                    data: Theme.of(context)
                        .copyWith(accentColor: Color(0xFF9B049B)),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                      strokeWidth: 2,
                      backgroundColor: Colors.white,
                    )),);
              default:
                if (snapshot.hasError) {
                  return buildText(
                      'Something Went Wrong Try later');
                } else {
                  final daily = dailyData;
                  if (daily.isEmpty) {
                    return buildText('No Daily Devotional Found');
                  } else
                    return Center(
                      child: Container(
                        child:   ListView.builder(
                            itemCount: dailydevo.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return Details(dailydevo[index]);
                                      },
                                      transitionsBuilder: (context, animation, secondaryAnimation, child){
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        padding: const EdgeInsets.only( bottom: 5, top: 5),
                                        width: 320,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(4))),
                                        child: Card(
                                          elevation: 4,
                                          child: Stack(
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: 170,
                                                        width: 320,
                                                        clipBehavior:
                                                        Clip.antiAliasWithSaveLayer,
                                                        decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(4),
                                                                topRight:
                                                                Radius.circular(4))),
                                                        child: Image.network(
                                                            '${dailydevo[index].image}',
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8.0, bottom: 2, top: 23),
                                                    child: Text('${dailydevo[index].title}',
                                                        style: GoogleFonts.openSans(
                                                            fontSize: 16,
                                                            color: Color(0xFF272b3f),
                                                            fontWeight: FontWeight.bold)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      '${dailydevo[index].body}',
                                                      style: GoogleFonts.openSans(
                                                        fontSize: 13,
                                                        color: Colors.black38,
                                                      ),
                                                      maxLines: 1,
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8.0, bottom: 12),
                                                    child: Row(
                                                      children: [
                                                        Text('•   From DailyDevotional •  ',
                                                            style: TextStyle(
                                                              color: Colors.black38,
                                                            )),
                                                        Icon(
                                                          Icons.book_outlined,
                                                          color: Colors.black38,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Positioned(
                                                top: 150,
                                                left: 120,
                                                child: Container(
                                                  width: 180,
                                                  child: Chip(
                                                      backgroundColor: Colors.white,
                                                      elevation: 3,
                                                      label: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Text('${Utils().compareDate(
                                                              daily[index].lastMessageTime).toString()}',
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: 15,
                                                                  color: Color(0xFF272b3f),
                                                                  fontWeight:
                                                                  FontWeight.bold)),
                                                        ],
                                                      )),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );

                              //   Card(
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: <Widget>[
                              //       ListTile(
                              //         onTap:(){
                              //           Navigator.push(
                              //             context,
                              //             PageRouteBuilder(
                              //               pageBuilder: (context, animation, secondaryAnimation) {
                              //                 return Details(dailydevo[index]);
                              //               },
                              //               transitionsBuilder: (context, animation, secondaryAnimation, child){
                              //                 return FadeTransition(
                              //                   opacity: animation,
                              //                   child: child,
                              //                 );
                              //               },
                              //             ),
                              //           );
                              //         },
                              //         leading: Hero(
                              //           tag:dailydevo[index].image  ,
                              //           child: Container(
                              //             height: 50,
                              //             width: 50,
                              //             child: Image.network(dailydevo[index].image, fit: BoxFit.cover,),
                              //             decoration: BoxDecoration(
                              //               shape: BoxShape.circle
                              //             ),
                              //           ),
                              //         ),
                              //         trailing:  Text(date),
                              //         title: Text(dailydevo[index].title),
                              //         subtitle: Text(dailydevo[index].body, maxLines: 1, overflow: TextOverflow.fade,),
                              //       ),
                              //     ],
                              //   ),
                              // );


                            }
                        ),
                      ),
                    );
                }
            }
          } else {
            return Center(child: Theme(
                data: Theme.of(context)
                    .copyWith(accentColor: Color(0xFF9B049B)),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                )),);
          }
        },
      ));




      // PageView(
      //   controller: controller,
      //   children: [
      //     StreamBuilder(
      //       stream:
      //       FirebaseApi.getDaily(),
      //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //         if (snapshot.hasData) {
      //           dailydevo = snapshot.data.docs
      //               .map((doc) => DailyDevo.fromMap(doc.data(), doc.id))
      //               .toList();
      //           List<DailyDevo> dailyData = [];
      //           for (var v in dailydevo) {
      //             dailyData.add(v);
      //           }
      //
      //           switch (snapshot.connectionState) {
      //             case ConnectionState.waiting:
      //               return Center(child: Theme(
      //                   data: Theme.of(context)
      //                       .copyWith(accentColor: Color(0xFF9B049B)),
      //                   child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
      //                     strokeWidth: 2,
      //                     backgroundColor: Colors.white,
      //                   )),);
      //             default:
      //               if (snapshot.hasError) {
      //                 return buildText(
      //                     'Something Went Wrong Try later');
      //               } else {
      //                 final daily = dailyData;
      //                 if (daily.isEmpty) {
      //                   return buildText('No Daily Devotional Found');
      //                 } else
      //                   return Center(
      //                     child: Container(
      //                       child:   ListView.builder(
      //                           itemCount: dailydevo.length,
      //                           itemBuilder: (context, index) {
      //                             return InkWell(
      //                               onTap: (){
      //                                 Navigator.push(
      //                                                 context,
      //                                                 PageRouteBuilder(
      //                                                   pageBuilder: (context, animation, secondaryAnimation) {
      //                                                     return Details(dailydevo[index]);
      //                                                   },
      //                                                   transitionsBuilder: (context, animation, secondaryAnimation, child){
      //                                                     return FadeTransition(
      //                                                       opacity: animation,
      //                                                       child: child,
      //                                                     );
      //                                                   },
      //                                                 ),
      //                                               );
      //                               },
      //                               child: Container(
      //                                 clipBehavior: Clip.antiAliasWithSaveLayer,
      //                                 decoration: BoxDecoration(
      //                                     borderRadius: BorderRadius.only(
      //                                         topLeft: Radius.circular(10),
      //                                         topRight: Radius.circular(10))),
      //                                 child: Column(
      //                                   mainAxisAlignment: MainAxisAlignment.start,
      //                                   crossAxisAlignment: CrossAxisAlignment.center,
      //                                   children: [
      //                                     Container(
      //                                       clipBehavior: Clip.antiAliasWithSaveLayer,
      //                                       padding: const EdgeInsets.only( bottom: 5, top: 5),
      //                                       width: 320,
      //                                       decoration: BoxDecoration(
      //                                           borderRadius:
      //                                           BorderRadius.all(Radius.circular(4))),
      //                                       child: Card(
      //                                         elevation: 4,
      //                                         child: Stack(
      //                                           children: [
      //                                             Column(
      //                                               mainAxisAlignment: MainAxisAlignment.start,
      //                                               crossAxisAlignment:
      //                                               CrossAxisAlignment.start,
      //                                               children: [
      //                                                 Stack(
      //                                                   children: [
      //                                                     Container(
      //                                                       height: 170,
      //                                                       width: 320,
      //                                                       clipBehavior:
      //                                                       Clip.antiAliasWithSaveLayer,
      //                                                       decoration: BoxDecoration(
      //                                                           color: Colors.transparent,
      //                                                           borderRadius: BorderRadius.only(
      //                                                               topLeft: Radius.circular(4),
      //                                                               topRight:
      //                                                               Radius.circular(4))),
      //                                                       child: Image.network(
      //                                                           '${dailydevo[index].image}',
      //                                                           fit: BoxFit.cover),
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                                 Padding(
      //                                                   padding: const EdgeInsets.only(
      //                                                       left: 8.0, bottom: 2, top: 23),
      //                                                   child: Text('${dailydevo[index].title}',
      //                                                       style: GoogleFonts.openSans(
      //                                                           fontSize: 16,
      //                                                           color: Color(0xFF272b3f),
      //                                                           fontWeight: FontWeight.bold)),
      //                                                 ),
      //                                                 Padding(
      //                                                   padding: const EdgeInsets.only(left: 8),
      //                                                   child: Text(
      //                                                     '${dailydevo[index].body}',
      //                                                     style: GoogleFonts.openSans(
      //                                                       fontSize: 13,
      //                                                       color: Colors.black38,
      //                                                     ),
      //                                                     maxLines: 1,
      //                                                     softWrap: true,
      //                                                     overflow: TextOverflow.ellipsis,
      //                                                   ),
      //                                                 ),
      //                                                 Padding(
      //                                                   padding: const EdgeInsets.only(
      //                                                       left: 8.0, bottom: 12),
      //                                                   child: Row(
      //                                                     children: [
      //                                                       Text('•   From DailyDevotional •  ',
      //                                                           style: TextStyle(
      //                                                             color: Colors.black38,
      //                                                           )),
      //                                                       Icon(
      //                                                         Icons.book_outlined,
      //                                                         color: Colors.black38,
      //                                                         size: 20,
      //                                                       ),
      //                                                     ],
      //                                                   ),
      //                                                 )
      //                                               ],
      //                                             ),
      //                                             Positioned(
      //                                               top: 150,
      //                                               left: 120,
      //                                               child: Container(
      //                                                 width: 180,
      //                                                 child: Chip(
      //                                                     backgroundColor: Colors.white,
      //                                                     elevation: 3,
      //                                                     label: Row(
      //                                                       mainAxisAlignment:
      //                                                       MainAxisAlignment.center,
      //                                                       crossAxisAlignment:
      //                                                       CrossAxisAlignment.center,
      //                                                       children: [
      //                                                         Text('${Utils().compareDate(
      //                                                             daily[index].lastMessageTime).toString()}',
      //                                                             style: GoogleFonts.openSans(
      //                                                                 fontSize: 15,
      //                                                                 color: Color(0xFF272b3f),
      //                                                                 fontWeight:
      //                                                                 FontWeight.bold)),
      //                                                       ],
      //                                                     )),
      //                                               ),
      //                                             )
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     )
      //                                   ],
      //                                 ),
      //                               ),
      //                             );
      //
      //                             //   Card(
      //                             //   child: Column(
      //                             //     mainAxisSize: MainAxisSize.min,
      //                             //     children: <Widget>[
      //                             //       ListTile(
      //                             //         onTap:(){
      //                             //           Navigator.push(
      //                             //             context,
      //                             //             PageRouteBuilder(
      //                             //               pageBuilder: (context, animation, secondaryAnimation) {
      //                             //                 return Details(dailydevo[index]);
      //                             //               },
      //                             //               transitionsBuilder: (context, animation, secondaryAnimation, child){
      //                             //                 return FadeTransition(
      //                             //                   opacity: animation,
      //                             //                   child: child,
      //                             //                 );
      //                             //               },
      //                             //             ),
      //                             //           );
      //                             //         },
      //                             //         leading: Hero(
      //                             //           tag:dailydevo[index].image  ,
      //                             //           child: Container(
      //                             //             height: 50,
      //                             //             width: 50,
      //                             //             child: Image.network(dailydevo[index].image, fit: BoxFit.cover,),
      //                             //             decoration: BoxDecoration(
      //                             //               shape: BoxShape.circle
      //                             //             ),
      //                             //           ),
      //                             //         ),
      //                             //         trailing:  Text(date),
      //                             //         title: Text(dailydevo[index].title),
      //                             //         subtitle: Text(dailydevo[index].body, maxLines: 1, overflow: TextOverflow.fade,),
      //                             //       ),
      //                             //     ],
      //                             //   ),
      //                             // );
      //
      //
      //                           }
      //                       ),
      //                     ),
      //                   );
      //               }
      //           }
      //         } else {
      //           return Center(child: Theme(
      //               data: Theme.of(context)
      //                   .copyWith(accentColor: Color(0xFF9B049B)),
      //               child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
      //                 strokeWidth: 2,
      //                 backgroundColor: Colors.white,
      //               )),);
      //         }
      //       },
      //     ),
      //
      //
      //
      //     StreamBuilder(
      //       stream:
      //       FirebaseApi.getPrayer(),
      //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //         if (snapshot.hasData) {
      //           dailydevo = snapshot.data.docs
      //               .map((doc) => DailyDevo.fromMap(doc.data(), doc.id))
      //               .toList();
      //           List<DailyDevo> dailyData = [];
      //           for (var v in dailydevo) {
      //             dailyData.add(v);
      //           }
      //           dailyData
      //             ..sort((b, a) =>
      //                 a.lastMessageTime.compareTo(b.lastMessageTime));
      //           switch (snapshot.connectionState) {
      //             case ConnectionState.waiting:
      //               return Center(child: Theme(
      //                   data: Theme.of(context)
      //                       .copyWith(accentColor: Color(0xFF9B049B)),
      //                   child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
      //                     strokeWidth: 2,
      //                     backgroundColor: Colors.white,
      //                   )),);
      //             default:
      //               if (snapshot.hasError) {
      //                 return buildText(
      //                     'Something Went Wrong Try later');
      //               } else {
      //                 final daily = dailyData;
      //                 if (daily.isEmpty) {
      //                   return buildText('No Prayer Found');
      //                 } else
      //                   return Container(
      //                     child: ListView.builder(
      //                         itemCount: daily.length,
      //                         itemBuilder: (context, index) {
      //                           return  Card(
      //                             child: ExpansionCard(
      //                               title: Container(
      //                                 child: Column(
      //                                   crossAxisAlignment: CrossAxisAlignment.start,
      //                                   children: <Widget>[
      //                                     Text(
      //                                       daily[index].title,
      //                                       style: TextStyle(color: Colors.black),
      //                                     ),
      //
      //                                   ],
      //                                 ),
      //                               ),
      //                               children: <Widget>[
      //                                 Container(
      //                                   margin: EdgeInsets.symmetric(horizontal: 7),
      //                                   child: Text(daily[index].body,
      //                                   ),
      //                                 )
      //                               ],
      //                             ),
      //                           );
      //                         }
      //                     ),
      //                   );
      //               }
      //           }
      //         } else {
      //           return Center(child: Theme(
      //               data: Theme.of(context)
      //                   .copyWith(accentColor: Color(0xFF9B049B)),
      //               child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
      //                 strokeWidth: 2,
      //                 backgroundColor: Colors.white,
      //               )),);
      //         }
      //       },
      //     ),
      //
      //
      //   ],
      // ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     elevation: 20,
    //     type: BottomNavigationBarType.fixed,
    //      currentIndex: customIndex,
    //     unselectedItemColor: Color(0xFF555555),
    //     selectedItemColor: Colors.brown,
    //     selectedLabelStyle: TextStyle(fontSize: 12),
    //     unselectedLabelStyle: TextStyle(fontSize: 12),
    //     onTap: (index){
    //       controller.jumpToPage(index);
    //       setState(() {
    //         customIndex = index;
    //       });
    //     },
    //     items: [
    //       BottomNavigationBarItem(
    //         label: 'Daily Devotional',
    //           icon:Icon( Icons.book_outlined, color: customIndex == 1?Colors.grey:Colors.brown,),
    //           activeIcon: Icon( Icons.book),
    //       ),
    //       BottomNavigationBarItem(
    //           label: 'Daily Prayer',
    //           icon:Icon( Icons.event_note, color: customIndex == 0?Colors.grey:Colors.brown),
    //           activeIcon: Icon( Icons.event_note_outlined)),
    //     ],
    //   ),

  }

   Widget buildText(String text) => Padding(
     padding: const EdgeInsets.all(100.0),
     child: Text(
       text,
       style: TextStyle(fontSize: 18, color: Colors.black38), textAlign: TextAlign.center,
     ),
   );
}
