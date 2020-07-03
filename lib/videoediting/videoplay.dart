import 'package:flutter/material.dart';
import 'package:music_application/Screens/home.dart';
import 'package:video_player/video_player.dart';
import 'package:music_application/chewie_plugin/chewie_list_item.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
class VideoPlay extends StatefulWidget {
  String videopath;
  int shareoption = 0;

  VideoPlay({this.videopath,this.shareoption});

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  VideoPlayerController _controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videopath));
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:Scaffold(
        backgroundColor: Colors.brown[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: ()
          {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Home()));
          },
          child: Icon(Icons.arrow_back),
        ),

        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Video Player"),
            widget.shareoption == 1 ?
            GestureDetector(
              onTap: (){
                ShareVideo();
              },

              child: Text("Share"),
            )
                :
            Text(""),
          ],
        ),

      ),

        body: SingleChildScrollView(
          child:Container(
            color: Colors.brown[200],
          height: MediaQuery.of(context).size.height*0.85,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ChewieListItem(
                  videoPlayerController: _controller
              ),
            ],
          ),
        )),

    ),
      onWillPop: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Home()));
      },
    );
  }


  void ShareVideo()
  {
    _controller.pause();
    print("Share Video");

    final RenderBox box = context.findRenderObject();
    //It shre text,videos
//    Share.share(widget.videopath,
//        subject: "why",
//        sharePositionOrigin:
//        box.localToGlobal(Offset.zero) &
//        box.size);

    //It share videos
   ShareExtend.share(widget.videopath, "Music App");
  }

}
