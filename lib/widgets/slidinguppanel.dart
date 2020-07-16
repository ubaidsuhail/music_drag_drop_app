import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:music_application/theme.dart';
import 'package:music_application/youtube_api/youtube_api.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//import 'dropbox.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:storage_path/storage_path.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:webview_media/webview_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_application/downloadvideos/downloadgalleryvideos.dart';
import 'package:music_application/downloadvideos/downloadyoutubevideos.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pt;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:convert';
import 'package:music_application/downloadvideos/downloadtiktokvideos.dart';
import 'package:music_application/sharedpreference/sharedpreferenceapp.dart';


class SlidingUpPanelTabs extends StatefulWidget {
  PanelController controller = PanelController();
  SlidingUpPanelTabs({Key key, this.controller});
  @override
  _SlidingUpPanelTabsState createState() => _SlidingUpPanelTabsState();
}

class _SlidingUpPanelTabsState extends State<SlidingUpPanelTabs>
    with SingleTickerProviderStateMixin {
  String url = 'https://api.dailymotion.com/videos?page=1';
  String url2 = 'https://api.dailymotion.com/videos?page=2';
  List<dynamic> data;
  List<dynamic> searchData;

  TextEditingController searchbar;
  Icon iconSearch = Icon(Icons.search);
  Widget barForDailymotion = Text(
    'dailymotion',
    style: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  TabController _controller;
  int currentPos;
  String stateText;
  //String apikey = 'AIzaSyDVklre5qoxkR7TVa11mp4Gr0B6yz1M8h4';
  String apikey = 'AIzaSyBgv2c0Rt4Ifb3aBcVrROi35nK0qqLVpXw';
  TextEditingController search;
  TextEditingController searchTikTok;
  YoutubePlayerController videoController;
  YoutubeAPI _youtubeAPI;
  List<YT_API> you_res;
  List<VideoItem> videoitem;
  List list = [];
  List paths = [];
  List videoName = [];
  //List<Uint8List> videoImg = [];
  final _flutterVideoCompress = FlutterVideoCompress();
  final picker = ImagePicker();
  List downloadedFiles = List();
  List<Uint8List> downloadedFileImage = [];
  var dir;
  String tikTokUrl = "";
  Map<String,String> tikTokApiKeyParameter = {"X-RapidAPI-Host":"tiktok.p.rapidapi.com","X-RapidAPI-Key":"d1de1eee2amsh766b14dacd457bbp108a3djsn0b7b60d26751"};
  Response tikTokApiResponse;
  Map<String,dynamic> tikTokKeyValues;
  List tikTokDataList = [];
  String tikTokApiError = "";
  SharedPreferenceApp shPrefApp = SharedPreferenceApp();



  Icon cusIcon = Icon(
    Icons.search,
    color: Colors.grey,
  );

  Widget barForYoutube = Image.asset(
    'assets/youtube.png',
    width: 98.0,
    height: 22.0,
  );
  Widget iconsadd = IconButton(
    icon: Icon(
      Icons.account_circle,
      color: Colors.grey,
    ),
    onPressed: () {},
  );


  Widget barForTikTok = Image.asset(
    'assets/tiktok.png',
    width: 98.0,
    height: 22.0,
  );

  Icon cusIconTikTok = Icon(
    Icons.search,
    color: Colors.grey,
  );




  bool onSearch = true;
  bool onSearchTikTok = true;

  @override
  void initState() {
    currentPos = 0;
    stateText = "Video not started";
    super.initState();
    _controller = new TabController(length: 4, vsync: this);

    search = TextEditingController();
    searchTikTok = TextEditingController();

    //TikTok videos

    TikTokVideos("");

    _youtubeAPI = YoutubeAPI(apikey, type: 'video', maxResults: 30);
    you_res = [];
    videoitem = [];

    callApi('YOUTUBE CHANNEL FIRST PAGE');

    super.initState();
    //run();

    searchbar = TextEditingController();
    //getRequest();

    GetDownloadedFiles();

  }


  //For Tik Tok Videos
  void TikTokVideos(String username) async
  {

    if(username == "")
      {
        tikTokUrl = "https://tiktok.p.rapidapi.com/live/trending/feed?limit=15";
      }

     else
       {
        tikTokUrl = "https://tiktok.p.rapidapi.com/live/user/feed?username=$username&limit=15";
       }

       tikTokApiResponse = await get(tikTokUrl,headers:tikTokApiKeyParameter);


     print("tik tok api response:${tikTokApiResponse.body}");
     print("tik tok status code:${tikTokApiResponse.statusCode}");

     //Agar sahi data aya to ya aiga
     if(tikTokApiResponse.statusCode == 200)
       {

         tikTokKeyValues = jsonDecode(tikTokApiResponse.body);

         if(tikTokKeyValues["media"].length == 0)
           {
             tikTokDataList = [];
             tikTokApiError = "Please enter correct user name";
           }
           else
             {
               tikTokDataList = tikTokKeyValues["media"];
               tikTokApiError = "";
             }


         print("Tik tok data list ${tikTokDataList}");
         print("tik tok data list length ${tikTokDataList.length}");


       }

      else if(tikTokApiResponse.statusCode == 404)
        {
          tikTokDataList = [];
          tikTokApiError = "Please enter correct user name";
        }

       else if(tikTokApiResponse.statusCode == 429)
         {
           tikTokDataList = [];
           tikTokApiError = "Tik tok api not working";
         }


        setState(() {
          tikTokApiError;
          tikTokDataList;
        });

     }


  Future<Null> callApi(String query) async {
    if (you_res.isNotEmpty) {
      videoitem.clear();
    }
    you_res = await _youtubeAPI.search(query);

    //print("Youtube api data is:"+you_res.toString());



    for (YT_API res in you_res) {

     // print("Response response:"+res.toString());

      VideoItem item = VideoItem(api: res);
      videoitem.add(item);
    }
    setState(() {});
  }


  void GetDownloadedFiles() async
  {
    //This will check whether video right or not
    String emptyVideo = await shPrefApp.GetYoutubeEmptyVideo();

    if(!(emptyVideo == null || emptyVideo == "1"))
      {
       File(emptyVideo).deleteSync();
       await shPrefApp.SetYoutubeEmptyVideo("1");
      }


    print("Empty video is:${emptyVideo}");

    //This will get the directory
    dir=await getExternalStorageDirectory();

    //This will get the list of downloaded files
    downloadedFiles = Directory("${dir.path}/musicappdj/").listSync();
    //print("Downloaded files path ${downloadedFiles}");

    for (int i = 0; i < downloadedFiles.length; i++) {

      try
      {
        final thumbnail = await _flutterVideoCompress.getThumbnail(
          downloadedFiles[i].path,
          quality: 80,
          position: -1,
        );
        print("thumbnail is ${thumbnail}");

        print("Downloaded file path ${pt.basename(downloadedFiles[i].path)}");

        downloadedFileImage.add(thumbnail);
      }

      catch(e)
      {
        final thumbnail = await VideoThumbnail.thumbnailData(
        video:downloadedFiles[i].path,
        imageFormat: ImageFormat.JPEG,
        quality: 80,
        maxWidth: 100,
        maxHeight: 100
        //position: -1,
      );

        print("thumbnail is ${thumbnail}");

        print("Downloaded file path ${pt.basename(downloadedFiles[i].path)}");

        downloadedFileImage.add(thumbnail);
      }

//      final thumbnail = await VideoThumbnail.thumbnailData(
//        video:downloadedFiles[i].path,
//        imageFormat: ImageFormat.JPEG,
//        quality: 100,
//        maxWidth: 100,
//        maxHeight: 100
//        //position: -1,
//      );


//      setState(() {
//        videoImg.add(thumbnail);
//      });

      //print("Downloaded files path ${downloadedFiles}");
//      print("Downloaded file path ${pt.basename(downloadedFiles[i].path)}");
//
//    downloadedFileImage.add(thumbnail);
    }


    setState(() {
      downloadedFiles;
      downloadedFileImage;
    });

    //print("hello");
    //print("Downloaded Files are ${downloadedFiles}");
  }




//  void run() async {
//    String video = await StoragePath.videoPath;
//    if (video != null) {
//      list = json.decode(video);
//
//      setState(() {
//        for (int i = 0; i < list[0]['files'].length; i++) {
//          if (!paths.contains(list[0]['files'][i]['path'])) {
//            paths.add(list[0]['files'][i]['path']);
//            videoName.add(list[0]['files'][i]['displayName']);
//          }
//        }
//        getVideoImage();
//      });
//    }
//  }

//  void getVideoImage() async {
//    for (int i = 0; i < paths.length; i++) {
//      final thumbnail = await _flutterVideoCompress.getThumbnail(
//        paths[i],
//        quality: 50,
//        position: -1,
//      );
//
//      setState(() {
//        videoImg.add(thumbnail);
//      });
//    }
//  }

//  Future<Null> getRequest() async {
//    var result = await http
//        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//    var result2 = await http
//        .get(Uri.encodeFull(url2), headers: {"Accept": "application/json"});
//    setState(() {
//      var res = json.decode(result.body);
//      var res2 = json.decode(result2.body);
//      data = res['list'];
//      data += res2['list'];
//
////      print("data is ${data}");
////      print("data2 is ${res}");
//    });
//
//
//
//
//  }

//  Future<Null> onSearchForDailymotion(String query) async {
//    List q = query.split(' ');
//    String dat = '';
//    for (int i = 0; i < q.length; i++) {
//      if (q[i] != ' ') dat = '$dat+${q[i]}';
//    }
//    if (dat[dat.length - 1] == '+')
//      dat = dat.substring(1, (dat.length - 1));
//    else
//      dat = dat.substring(1, dat.length);
//
//    print(
//        '-------------------------------------------------------------------------------$dat');
//    String searchApi =
//        'https://api.dailymotion.com/videos?fields=id,thumbnail_url,title%2Ctitle&country=pk&search=$dat&limit=50';
//
//    var resSearch = await http.get(Uri.encodeFull(searchApi),
//        headers: {"Accept": "application/json"});
//    setState(() {
//      var res = json.decode(resSearch.body);
//      searchData = res['list'];
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: new Scaffold(
        body: new Column(
          children: <Widget>[
            new TabBar(
              unselectedLabelColor: theme.primaryColor,
              indicatorColor: theme.primaryColor,
              controller: _controller,
              labelColor: theme.primaryColor,
              isScrollable: true,
              tabs: [
                new Tab(
                  text: 'Gallery',
                ),
                new Tab(
                  text: 'TikTok',
                ),
                new Tab(
                  icon: Image.asset(
                    "assets/youtube.png",
                    height: 80,
                    width: 80,
                  ),
                ),
                new Tab(
                  text: 'Downloaded',
                ),
              ],
            ),
            new Flexible(
              child: new TabBarView(
                controller: _controller,
                children: <Widget>[
                  //Gallery code starts

//                  GestureDetector(
//
//                    onTap: ()
//                    {
//                      GetGalleryVideo(context);
//                    },
//                    child: Text("Go to Gallery"),
//                  ),

                  NiceButton(
                    radius: 25,
                    elevation: 0.0,
                    text: "Go to Gallery",
                    icon: Icons.file_download,
                    gradientColors: [Color(0xff5b86e5), Color(0xff36d1dc)],

                    onPressed: () {
                      GetGalleryVideo(context);
                    },
                  ),

                  //For Tik Tok videos Start

              Scaffold(
                appBar: AppBar(
                  leading: Container(),
                  backgroundColor: Colors.white,
                  title: barForTikTok,
                  actions: <Widget>[
                    IconButton(
                      icon: cusIconTikTok,
                      onPressed: () {
                        setState(() {
                          if (this.cusIconTikTok.icon == Icons.search) {
                            this.cusIconTikTok = Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            );
                            this.barForTikTok = TextFormField(
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                hintText: 'Search tiktoker user name',
                              ),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              controller: searchTikTok,
                              onFieldSubmitted: (String username) async {
                                TikTokVideos(username);
                              },
                            );
                            setState(() {
                              onSearchTikTok = !onSearchTikTok;
                            });
                          } else {
                            this.cusIconTikTok = Icon(
                              Icons.search,
                              color: Colors.grey,
                            );
                            setState(() {
                              onSearchTikTok = true;
                              searchTikTok.clear();
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                body:Container(
                    child: tikTokApiError == "" ?
                    ListView.builder(
                        itemCount: tikTokDataList.length,
                        itemBuilder: (context, index) {
                         return Container(
                            color: Colors.white,
                            child: Card(
                              child: ListTile(
                                leading: Image.network(tikTokDataList[index]["video"]["cover"],width: MediaQuery.of(context).size.width*0.28,height: MediaQuery.of(context).size.width*0.15,fit: BoxFit.fill,),
                                title: Text(
                                  tikTokDataList[index]["description"] == "" ? "Tik tok video" : tikTokDataList[index]["description"] ,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  tikTokDataList[index]["author"]["nickname"],
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DownloadTikTokVideos(tikTokDataList[index]["description"],tikTokDataList[index]["author"]["nickname"],tikTokDataList[index]["video"]["playAddr"],context)),
                                  );
                                },
                              ),
                            ),
                          );


                        }
                    )
                    :
                    Text(tikTokApiError),

              ),
              ),



                  //For Tik Tok videos End




                  //For youtube videos
                  Scaffold(
                    appBar: AppBar(
                      leading: Container(),
                      backgroundColor: Colors.white,
                      title: barForYoutube,
                      actions: <Widget>[
                        IconButton(
                          icon: cusIcon,
                          onPressed: () {
                            setState(() {
                              if (this.cusIcon.icon == Icons.search) {
                                this.cusIcon = Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                );
                                this.barForYoutube = TextFormField(
                                  textInputAction: TextInputAction.go,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                    hintText: 'Search...',
                                  ),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                  controller: search,
                                  onFieldSubmitted: (String query) async {
                                    await callApi(query);
                                    setState(() {});
                                  },
                                );
                                setState(() {
                                  onSearch = !onSearch;
                                });
                              } else {
                                this.cusIcon = Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                );
                                setState(() {
                                  onSearch = true;
                                  search.clear();
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    body: Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount: videoitem.length,
                                  itemBuilder: (_, int index) =>
                                      videoitem[index],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stack(children: <Widget>[
                  //   DragBox(Offset(0.0, 0.0), 'Box One', Colors.blueAccent),
                  //   DragBox(Offset(200.0, 0.0), 'Box Two', Colors.orange),
                  //   DragBox(Offset(300.0, 0.0), 'Box Three', Colors.lightGreen),
                  // ]),

                  //For download videos
                  Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Text('downloaded videos', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black,)),
                      backgroundColor: Colors.white,
//                      actions: <Widget>[
//                        IconButton(
//                            icon: iconSearch,
//                            color: Colors.white,
//                            onPressed: () {
//                              setState(() {
//                                if (this.iconSearch.icon == Icons.search) {
//                                  this.iconSearch = Icon(
//                                    Icons.cancel,
//                                    color: Colors.white,
//                                  );
//                                  this.barForDailymotion = TextFormField(
//                                    textInputAction: TextInputAction.go,
//                                    decoration: InputDecoration(
//                                        contentPadding: EdgeInsets.fromLTRB(
//                                            5.0, 0.0, 0.0, 0.0),
//                                        hintText: 'Search...',
//                                        hintStyle: TextStyle(
//                                          color: Colors.white,
//                                          fontSize: 16.0,
//                                        ),
//                                        enabledBorder: OutlineInputBorder(
//                                            borderSide: BorderSide(
//                                                color: Colors.white))),
//                                    style: TextStyle(
//                                      fontSize: 16.0,
//                                      color: Colors.white,
//                                    ),
//                                    controller: searchbar,
//                                    onFieldSubmitted: (String query) {
//                                      onSearchForDailymotion(query);
//                                    },
//                                  );
//                                } else {
//                                  this.iconSearch = Icon(
//                                    Icons.search,
//                                    color: Colors.white,
//                                  );
//                                  this.barForDailymotion = Text(
//                                    'dailymotion',
//                                    style: TextStyle(
//                                      fontSize: 20.0,
//                                      fontWeight: FontWeight.bold,
//                                      color: Colors.white,
//                                    ),
//                                  );
//                                }
//                              });
//                            }),
//                      ],
                    ),
                    body: Container(
                      child:downloadedFiles.length !=0 ?

                          downloadedFiles.length == downloadedFileImage.length ?

                      ListView.builder(
                              itemCount: downloadedFiles.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0,right: 25.0,top: 8.0,bottom: 8.0),
                                    child: Draggable(
                                      data:{"videoimage":downloadedFileImage[index],"videopath":downloadedFiles[index].path} ,
                                      child:ListTile(
                                      leading: Image.memory(
                                        downloadedFileImage[index],
                                        height: 100.0,
                                        width: 100.0,
                                        fit: BoxFit.fill,
                                      ),
//
                                      title: Text(pt.basenameWithoutExtension(downloadedFiles[index].path)),
//                                      subtitle:
//                                          Text('${data[index]['channel']}'),

                                      onTap: (){

                                      },
                                    ),
                                    feedback: Material(
                                      child: ConstrainedBox(
                                        constraints:
                                        BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.9),
                                        child: ListTile(
                                          leading: Image.memory(
                                            downloadedFileImage[index],
                                            height: 100.0,
                                            width: 100.0,
                                            fit: BoxFit.fill,
                                          ),
//
                                          title: Text(pt.basenameWithoutExtension(downloadedFiles[index].path)),
//                                      subtitle:
//                                          Text('${data[index]['channel']}'),
                                        ),
                                      ),
                                      elevation: 6.0,
                                    ),
                                    ),
                                  ),
                                );


                              }
                              )
                          :
                             Center(child:CircularProgressIndicator())
                          :
                             Center(child:Container(child:Text("No Downloaded Video",style: TextStyle(fontSize: 20.0),))),

                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void GetGalleryVideo(BuildContext context) async
  {
    final pickedFileVideo = await picker.getVideo(source: ImageSource.gallery);
    print("Path of picked file is:${pickedFileVideo.path}");

    //Yaha sa ab hum gallery ki video ko download krna wali screen pr jai ga

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
          builder: (context) => DownloadGalleryVideos(pickedFileVideo.path)
    ),
    );

  }
}

class VideoItem extends StatelessWidget {
  final YT_API api;

  const VideoItem({Key key, this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        child: ListTile(
          leading: Image.network(api.thumbnail['high']['url']),
          title: Text(
            api.title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            api.channelTitle,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DownloadYoutubeVideos(api, context)),
            );
          },
        ),
      ),
    );
  }
}

//class PlayerForYoutube extends StatelessWidget {
//  String videoId;
//  YoutubePlayerController _controller;
//  YT_API _yi_api;
//
//  PlayerForYoutube(YT_API api, BuildContext context) {
//    //onTap(api, context);
//    _yi_api = api;
//    _controller = YoutubePlayerController(
//      initialVideoId: api.id,
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          'Youtube',
//          style: TextStyle(color: Colors.black),
//        ),
//        centerTitle: true,
//        backgroundColor: Colors.redAccent[700],
//      ),
//      body: Container(
//        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
//        color: Colors.grey[100],
//        child: SingleChildScrollView(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              YoutubePlayer(
//                controller: _controller,
//              ),
//              SizedBox(height: 20.0),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  _yi_api.title,
//                  style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    fontSize: 20.0,
//                  ),
//                ),
//              ),
//              SizedBox(height: 10.0),
//              Divider(
//                height: 5.0,
//                color: Colors.grey,
//              ),
//              SizedBox(height: 10.0),
//              Row(
//                children: <Widget>[
//                  SizedBox(width: 10.0),
//                  Icon(
//                    Icons.account_circle,
//                    color: Colors.grey,
//                  ),
//                  SizedBox(width: 10.0),
//                  Text(
//                    _yi_api.channelTitle,
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      fontSize: 15.0,
//                    ),
//                  ),
//                ],
//              ),
//              SizedBox(height: 10.0),
//              Divider(
//                height: 5.0,
//                color: Colors.grey,
//              ),
//              SizedBox(height: 20.0),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  'Description: ${_yi_api.description}',
//                  style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                  ),
//                ),
//              ),
//
//
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}

//class PlayerForDailymotion extends StatefulWidget {
//  final String url;
//
//  PlayerForDailymotion({this.url});
//
//  @override
//  _PlayerForDailymotionState createState() => _PlayerForDailymotionState();
//}

//class _PlayerForDailymotionState extends State<PlayerForDailymotion> {
//  final Completer<WebViewController> _controller =
//      Completer<WebViewController>();
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          'dailymotion',
//          style: TextStyle(
//            fontSize: 20.0,
//            fontWeight: FontWeight.bold,
//            color: Colors.white,
//          ),
//        ),
//        backgroundColor: Colors.black,
//      ),
//      body: WebView(
//        initialUrl: widget.url,
//        javascriptMode: JavascriptMode.unrestricted,
//        onWebViewCreated: (WebViewController webviewController) {
//          _controller.complete(webviewController);
//        },
//      ),
//    );
//  }
//}
