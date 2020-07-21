import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:music_application/youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ye;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:nice_button/nice_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_application/Screens/home.dart';
import 'package:music_application/sharedpreference/sharedpreferenceapp.dart';
import 'package:http/http.dart';
import 'dart:convert';

class DownloadYoutubeVideos extends StatelessWidget {
  String videoId;
  YoutubePlayerController _controller;
  YT_API _yi_api;
  var dir;
  List directoryDownloadedFilesList = List();
  var manifest;
  var videoWithoutAudio;
  Stream<List<int>> bytes;
  String downloadFilePath = "";
  int sum=0;
  ProgressDialog pr;
  String videoTitle = "";
  SharedPreferenceApp shPrefApp = SharedPreferenceApp();
  Map<String,String> youTubeApiKeyParameter = {"X-RapidAPI-Host":"youtube-video-info.p.rapidapi.com","X-RapidAPI-Key":"65dc8858a4msh0c502f5ec3f689ep140b88jsn3e855e858d78"};
  String youTubeServerVideoUrl = "";
  String youTubeDownloadVideoUrl = "";
  Response youTubeApiResponse;
  int downloadProgress = 0;

  DownloadYoutubeVideos(YT_API api, BuildContext context) {
    //onTap(api, context);
    _yi_api = api;
    _controller = YoutubePlayerController(
      initialVideoId: api.id,
    );

    pr = ProgressDialog(context,type: ProgressDialogType.Download,isDismissible: false);





  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()));
        }),
        title: Text(
          'Youtube',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent[700],
      ),
      body:FutureBuilder(
            future: GetYoutubeVideoUrl(),
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
            child: CircularProgressIndicator(),
             );

        else {
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              YoutubePlayer(
                controller: _controller,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _yi_api.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    _yi_api.channelTitle+_yi_api.id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description: ${_yi_api.description}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              Container(
                padding: EdgeInsets.only(top:20.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                  child: NiceButton(
                    radius: 25,
                    elevation: 0.0,
                    text: "Download",
                    icon: Icons.file_download,
                    gradientColors: [Color(0xffff5252), Color(0xffef9a9a)],

                    onPressed: () {
                      DownloadYoutubeVideo(context);
                    },
                  )
              ),


            ],
          ),
        ),
      );
    }
    }),
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





  Future GetYoutubeVideoUrl() async
  {
    print("Url agaya ha");

    youTubeServerVideoUrl = "https://youtube-video-info.p.rapidapi.com/video_formats?video=${_yi_api.id}";

    youTubeApiResponse = await get(youTubeServerVideoUrl,headers:youTubeApiKeyParameter);

    print("Response body is ${youTubeApiResponse.body}");

    print("Response Status code is ${youTubeApiResponse.statusCode}");


    if(youTubeApiResponse.statusCode == 200)
      {
        youTubeDownloadVideoUrl = jsonDecode(youTubeApiResponse.body)["Both_Audio_Video"][0]["Link"];
        print("Youtube Download video url is:$youTubeDownloadVideoUrl");
      }

      else
        {
          youTubeDownloadVideoUrl = "";
        }


  }







  void DownloadYoutubeVideo(BuildContext context) async
  {

    if(youTubeDownloadVideoUrl != "")
      {


    //This will pause the video
    _controller.pause();


    //Set Progress bar
    pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: downloadProgress.toDouble(),
      maxProgress: 100.0,
    );



    //This will show Alert Dialog
    await pr.show();


    //This will get the directory
    dir=await getExternalStorageDirectory();


    //This will get the list of downloaded files
    directoryDownloadedFilesList = Directory("${dir.path}/musicappdj/").listSync();
    print("Downloaded files list ${directoryDownloadedFilesList} and length is: ${directoryDownloadedFilesList.length}");




    //This will get the title of youtube video and replace empty space with -
    videoTitle = _yi_api.title.replaceAll(" ", "_");
    videoTitle = videoTitle.replaceAll("/", "_");
    videoTitle = videoTitle.replaceAll(".", "_");

    //Path where to download file
    downloadFilePath=dir.path+"/musicappdj"+"/Vi${directoryDownloadedFilesList.length + 1}" + videoTitle + ".mp4";


    //Now set file in shared preference if before download user will close the app
    await shPrefApp.SetYoutubeEmptyVideo(downloadFilePath);


    //Now download File Code
    await HttpClient().getUrl(Uri.parse(youTubeDownloadVideoUrl)).then((request) async{
      await request.close().then((response) async{
        var tot=response.contentLength;
        print("tot is: "+tot.toString());
        File f=File(downloadFilePath);
        int sum=0;
        var sub=response.asBroadcastStream().listen((List<int> event) {
          f.writeAsBytesSync(event,mode:FileMode.append);
          sum=sum+event.length;
          downloadProgress = ((sum / tot) *100) .toInt();

        //  print("sum is: "+sum.toString());

          if(downloadProgress < 50)
          {
            pr.update(
                progress: downloadProgress.toDouble(), message: "Please Wait");
          }
          else if(downloadProgress < 90)
          {
            pr.update(
                progress: downloadProgress.toDouble(), message: "Few Minutes Remaining");
          }

          else
            {
              pr.update(
                  progress: downloadProgress.toDouble(), message: "Almost complete");
            }
        });

        sub.onDone(() {
          print("compare is: "+sum.toString()+" == "+tot.toString());

          //Now set file in shared preference if download complete
          shPrefApp.SetYoutubeEmptyVideo("1");

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




        });
      });
    });




      }

      else
        {
          Fluttertoast.showToast(
              msg: "Download Url is not Correct",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue[300],
              textColor: Colors.white,
              fontSize: 16.0
          );
        }

  }



}