import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as pt;
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:music_application/chewie_plugin/chewie_list_item.dart';
import 'package:video_player/video_player.dart';
import 'package:nice_button/nice_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_application/Screens/home.dart';

class DownloadGalleryVideos extends StatefulWidget {
  String galleryVideoPath = "";

  DownloadGalleryVideos(this.galleryVideoPath) ;


  @override
  _DownloadGalleryVideosState createState() => _DownloadGalleryVideosState();
}

class _DownloadGalleryVideosState extends State<DownloadGalleryVideos> {
  var dir;
  List directoryDownloadedFilesList = List();
  File galleryFilePath;
  String galleryFileName;
  var bytes;
  String downloadFilePath;
  File writeFile;
  int sum=0;
  VideoPlayerController _controller;
  ProgressDialog pr;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.galleryVideoPath));
    pr = ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
    );
   // DownloadGalleryVideos();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()));
        }),
        title: Text("Downloading Gallery Videos"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
        color: Colors.white,
        child:Column(
          children: <Widget>[
            SizedBox(height: 20.0,),

            Text("VIDEO",style: TextStyle(fontSize: 20,color: Colors.blue),),

            SizedBox(height:15.0),

            ChewieListItem(
              videoPlayerController: _controller
            ),


//            GestureDetector(
//              onTap: (){
//              DownloadGalleryVideos(context);
//              },
//              child: Text("Download"),
//            ),


            SizedBox(height: 30.0,),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
              NiceButton(
              radius: 25,
                elevation: 0.0,
                text: "Download",
                icon: Icons.file_download,
                gradientColors: [Color(0xffff5252), Color(0xffef9a9a)],

                onPressed: () {
                  DownloadGalleryVideos(context);
                },
              )
                ],
              ),

            )

          ],
        )),
      ),
    ),
    onWillPop: (){
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home()));
    },
    );
  }


void DownloadGalleryVideos(BuildContext context) async
  {

    //This will pause the video
    _controller.pause();


    //This will show Alert Dialog

    await pr.show();

//    showDialog(
//      context: context,
//        builder: (context) {
//          return Center(
//              child:Container(
//                margin: EdgeInsets.only(left: 50.0),
//                child:Text("Downloading ...",style: TextStyle(color: Colors.black,fontSize: 28.0,decoration: TextDecoration.none),),
//              ));
//        });



    //This will get the directory
    dir=await getExternalStorageDirectory();

    //This will get the list of downloaded files
    directoryDownloadedFilesList = Directory("${dir.path}/musicappdj/").listSync();
    print("Downloaded files list ${directoryDownloadedFilesList} and length is: ${directoryDownloadedFilesList.length}");

    //This will convert the path of file to the file that needs to download
    galleryFilePath = File(widget.galleryVideoPath);
    print("Gallery file path ${galleryFilePath}");


    //This will get the name of the file
    galleryFileName = pt.basenameWithoutExtension(galleryFilePath.path);
    print("Gallery file name ${galleryFileName}");

    //Convert file data in to streams
    bytes =  ByteStream(DelegatingStream.typed(galleryFilePath.openRead()));

    //Path where to download file
    downloadFilePath=dir.path+"/musicappdj"+"/Vi${directoryDownloadedFilesList.length + 1}" + galleryFileName + ".mp4";


    //Assign path to write file object in which file is written
    writeFile = File(downloadFilePath);


    //Write streams in to file which means download file
    bytes.asBroadcastStream().listen((List<int> event) {
      writeFile.writeAsBytesSync(event,mode:FileMode.append);
      sum=sum+event.length;
      print("sum is: "+sum.toString());
    },
    onDone : (){
       print("Downloading Complete");
       Navigator.of(context, rootNavigator: true).pop();

       Fluttertoast.showToast(
           msg: "Downloading Complete",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.blue[300],
           textColor: Colors.white,
           fontSize: 16.0
       );


       //Navigator.pop(context);
      }
    );




  }

}
