import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:music_application/videoediting/videoplay.dart';

class SaveVideos extends StatefulWidget {
  @override
  _SaveVideosState createState() => _SaveVideosState();
}

class _SaveVideosState extends State<SaveVideos> {
  var dir;
  List saveVideosList = List();
  List saveVideosThumbnail = List();
  var thumbnail;
  final _flutterVideoCompress = FlutterVideoCompress();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Save Videos"),
    ),
      body: FutureBuilder(
        future: FinalSaveVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          else {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.875,
              width: MediaQuery.of(context).size.width,

              child:ListView.builder(
                  itemCount: saveVideosList.length,
                  itemBuilder: (BuildContext context , int index){
                    return GestureDetector(
                    onTap: (){
                    PlayVideo(saveVideosList[index].path);
                    },
                      child:Container(
                      height: MediaQuery.of(context).size.height*0.2 ,
                      width: MediaQuery.of(context).size.width * 0.84,
                      margin: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.08,right: MediaQuery.of(context).size.width * 0.08,top: 10.0),
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.tealAccent[100],width: 0.5),
                        ),

                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child:Image.memory(saveVideosThumbnail[index],fit: BoxFit.fill,),

                    ),
                    )
                      )
                    );
                  }

              )



            );

          }
        }),

        );
  }


  Future FinalSaveVideos() async
    {
      //This will get the directory
      dir=await getExternalStorageDirectory();
      saveVideosList = [];
      saveVideosThumbnail = [];

      //This will get the list of Save Video files
      saveVideosList = Directory("${dir.path}/savefinalvideos/").listSync();


      print("Save Videos List ${saveVideosList}");


      for(int i=0;i<saveVideosList.length; i++)
        {
           thumbnail = await _flutterVideoCompress.getThumbnail(
            saveVideosList[i].path,
            quality: 80,
            position: -1,
          );

           saveVideosThumbnail.add(thumbnail);


        }
      print("Save Videos List ${saveVideosThumbnail}");
      print("Save videos Length ${saveVideosThumbnail.length}");


    }



   void PlayVideo(String videoPath)
   {
     //Pop save video screen
     Navigator.pop(context);

     //Pop home screen
     Navigator.pop(context);

     Navigator.push(context, MaterialPageRoute(
         builder: (context) => VideoPlay(videopath:videoPath,shareoption:1)));
   }


}
