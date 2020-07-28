import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:music_application/chewie_plugin/chewie_list_item_sync.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pt;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_application/staticclasses/staticdata.dart';
import 'package:music_application/Screens/home.dart';
import 'package:music_application/sharedpreference/sharedpreferenceapp.dart';

class VideoSync extends StatefulWidget {

  String videopath,audiopath;
  int videoindex;

   VideoSync({this.videopath,this.audiopath,this.videoindex});


  @override
  _VideoSyncState createState() => _VideoSyncState();
}

class _VideoSyncState extends State<VideoSync> {

  VideoPlayerController _controller;
  Directory dir;
  List saveFinalVideosFiles = List();
  String saveVideosOuputPath = "";
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  ProgressDialog pr;

  SharedPreferenceApp shPrefApp = SharedPreferenceApp();

  int videoNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videopath));
    pr = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);
    pr.style(
      message: 'Sync file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()));
        }),
        title: Text("Sync Audio and Video"),
      ),
      body:SingleChildScrollView(
      child:Container(
        height: MediaQuery.of(context).size.height * 0.87,
        width: MediaQuery.of(context).size.width,

        child: Column(
          children: <Widget>[

            SizedBox(height: 10.0,),

            Text("Video",style: TextStyle(fontSize: 30.0),),

            SizedBox(height: 20.0,),

            Container(
              height: MediaQuery.of(context).size.height*0.35,
              width: MediaQuery.of(context).size.width,
            child:ChewieListItemSync(
                videoPlayerController: _controller
            )),

            SizedBox(height: 20.0,),
            Text("Audio",style: TextStyle(fontSize: 30.0),),

            SizedBox(height: 10.0,),

            Container(
                margin: EdgeInsets.only(left: 10.0,right:10.0),
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.purple[200],),
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  color:Colors.brown,
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Audio File",style: TextStyle(fontSize: 30.0),),
                  ],
                )
            ),

        Expanded(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
        Container(

        width: MediaQuery.of(context).size.width*0.6,
            height: MediaQuery.of(context).size.height/15,
            margin: EdgeInsets.only(bottom: 10.0),

            child:RaisedButton(
              color: Colors.lightBlue[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),

              onPressed: (){
                SyncAudioAndVideo();
              },


              child:Text("Sync"),

            ))
          ],
        ),
        ),


          ],

        ),


      )
      ),
    ),
      onWillPop: (){
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home()));
      },);
  }



  void SyncAudioAndVideo() async
  {

    //This will show how much video not shown by user
    videoNumber = await shPrefApp.GetSyncVideo();

    print("Video Number is:${videoNumber}");

    if(videoNumber == null)
      {
        videoNumber = 0 ;
      }


    //This will pause the video
    _controller.pause();


    //This will show Alert Dialog
    await pr.show();


    dir=await getExternalStorageDirectory();
    saveFinalVideosFiles = Directory("${dir.path}/savefinalvideos/").listSync();

    print("Length of saveFinalVideosFiles: ${saveFinalVideosFiles.length}");

    print("path is:${widget.videopath}");

    saveVideosOuputPath = dir.path+"/savefinalvideos"+"/FSV${saveFinalVideosFiles.length + 1}_${pt.basename(widget.videopath)}";


    //Sync Audio with Video
    // -shortest means video ya audio ma sa jo choti hogi utna hi chalega
    //-stream_loop -1 means infinite bar audio loop hogi
    //Ya command uswaqt chaya jb ogg ki audio file nhi chaya(Ya fast ha)
    _flutterFFmpeg.execute("-i ${widget.videopath} -stream_loop -1 -i '${widget.audiopath}' -c copy -map 0:v:0 -map 1:a:0 -shortest ${saveVideosOuputPath}").then((rc){
      print("FFmpeg process exited with rc $rc");

      if(rc == 0)
      {
        //This will remove video from list
       StaticData.dragDropVideoList.removeAt(widget.videoindex);

       //Now increase the video number length
       shPrefApp.SetSyncVideo(videoNumber + 1);



        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Sync Complete",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.pop(context);
//        Navigator.push(context, MaterialPageRoute(
//            builder: (context) => VideoSync(videopath:saveVideosOuputPath,audiopath:StaticData.audioFilePath)));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home()));

      }
      else
      {
        Navigator.of(context, rootNavigator: true).pop();

        Fluttertoast.showToast(
            msg: "Error in Syncing",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

    });

    //or
    //Ya uswaqt chaya jb sb audio file chala
    //_flutterFFmpeg.execute("-i ${inputVideo.path} -stream_loop -1 -i ${audiopath} -c:v copy -map 0:v:0 -map 1:a:0 -c:a aac -b:a 192k -shortest ${outputPath}").then((rc) => print("FFmpeg process exited with rc $rc"));






  }


}
