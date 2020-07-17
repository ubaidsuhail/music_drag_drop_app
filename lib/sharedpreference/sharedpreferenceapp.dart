import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceApp
{


  void SetUserName(String username) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("username",username);

  }


  Future<String> GetUserName() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("username");
  }




  Future SetYoutubeEmptyVideo(String video) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("youtubevideo", video);

  }


  Future<String> GetYoutubeEmptyVideo() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

   return prefs.getString("youtubevideo");


  }


  Future SetFilterEmptyVideo(String video) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("filtervideo", video);

  }


  Future<String> GetFilterEmptyVideo() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("filtervideo");

  }


  Future SetSyncVideo(int number) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("syncvideo", number);
  }

  Future<int> GetSyncVideo() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt("syncvideo");

  }

}

