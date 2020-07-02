import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_application/Screens/signup.dart';
import 'package:music_application/widgets/fullscreenloader.dart';
import 'package:music_application/widgets/textformfield.dart';
import '../global.dart';
import '../theme.dart';
import 'home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool passwordVisibleLogin = false;

  Function onPressedLogin() {
    setState(() {
      passwordVisibleLogin = !passwordVisibleLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
                child: Stack(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: AssetImage("assets/background.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Hero(
                          child: Image(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 2,
                            image: AssetImage(
                              SplashScreenConfig.logoAssetName,
                            ),
                          ),
                          tag: 'logo',
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: AppPadding.formFieldPadding[0],
                                  right: AppPadding.formFieldPadding[0],
                                  top: 40,
                                ),
                                child: MusicTextFormField(
                                  controller: emailController,
                                  hintText: 'Enter Your Email',
                                  validatorFunction: (String text) {
                                    if (text.isEmpty) {
                                      return 'Input phone number';
                                    }
                                  },
                                  isPassField: false,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: AppPadding.formFieldPadding[0],
                                  right: AppPadding.formFieldPadding[0],
                                ),
                                child: MusicTextFormField(
                                  controller: passController,
                                  hintText: 'Enter Your Password',
                                  validatorFunction: (String text) {
                                    if (text.isEmpty) {
                                      return 'Input password';
                                    }
                                  },
                                  isPassField: true,
                                  isPasswordVisible: passwordVisibleLogin,
                                ),
                              ),
                              Container(
                                child: MaterialButton(
                                  height: MediaQuery.of(context).size.width / 8,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: theme.primaryColor),
                                  ),
                                  color: Colors.white,
                                  onPressed: () async {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => Home()));

                                    signInWithEmail(emailController.text.trim(),
                                        passController.text);

                                    if (emailController.text.isEmpty ||
                                        passController.text.isEmpty) {
                                      print(
                                          'Email and password cannot be empty');
                                      return;
                                    }
                                    bool res = await signInWithEmail(
                                        emailController.text.trim(),
                                        passController.text);
                                    if (!res) {
                                      print('Login failed');
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "Error",
                                        desc: "Login Failed",
                                        buttons: [
                                          DialogButton(
                                            child: Text("DISMISS",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title
                                                    .copyWith(
                                                      color: Colors.white,
                                                    )),
                                            color: theme.accentColor,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ).show();
                                    } else {

                                      TakePermission();

//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) => Home()));
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                left: AppPadding.formFieldPadding[1],
                                right: AppPadding.formFieldPadding[1],
                                bottom: AppPadding.formFieldPadding[1],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text('    Or    ',
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      )),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 6,
                                  right: MediaQuery.of(context).size.width / 6,
                                ),
                                child: MaterialButton(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 45.0, left: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Image(
                                          image:
                                              AssetImage('assets/google.png'),
                                          height: 18,
                                        ),
                                        Text(
                                          'Login With Google',
                                          style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onPressed: () async {
                                    bool res = await loginWithGoogle();
                                    if (!res) {
                                      print("Error logging in with google");
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "Error",
                                        desc: "Login Failed",
                                        buttons: [
                                          DialogButton(
                                            child: Text("DISMISS",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title
                                                    .copyWith(
                                                      color: Colors.white,
                                                    )),
                                            color: theme.accentColor,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ).show();
                                    } else {

                                      //TakePermission
//
                                      TakePermission();

//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) => Home()));
                                    }
                                  },
                                )),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15, color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  child: Text(
                                    " Signup now",
                                    style: GoogleFonts.roboto(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                )),
          ),
        )),
        _isLoading ? FullScreenLoader() : Container()
      ],
    );
  }

  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) return false;
      setState(() => _isLoading = true);
      AuthResult res =
          await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      setState(() {
        _isLoading = false;
      });
      if (res.user == null) return false;
      return true;
    } catch (e) {
      print(e.message);
      print("Error logging with google");
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: e.message,
        buttons: [
          DialogButton(
            child: Text("DISMISS",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: theme.accentColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      setState(() {
        _isLoading = false;
      });
      FirebaseUser user = result.user;

      if (user != null)
        return true;
      else
        return false;
    } catch (e) {
      print(e.message);
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: e.message,
        buttons: [
          DialogButton(
            child: Text("DISMISS",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: theme.accentColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void TakePermission() async
  {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print("Storage permission is:${statuses[Permission.storage]}");

    CreateDownloadFileDirectory();

  }

  void CreateDownloadFileDirectory() async
  {

    //This will get a directory path
    var dir=await getExternalStorageDirectory();


    //Check if Directory exists
    if(await Directory(dir.path+"/musicappdj").exists())
    {
      print("Directory exists");
    }
    else
      {
        //This function creates a directory
        var createDirectory =  await Directory(dir.path+"/musicappdj").create();
        print("Newly create downloaded directory is:"+createDirectory.path);
      }


      CreateTrimVideosDirectory();

//      //This will sent to home page
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => Home()));






  }

  //Create Trim Videos Directory
  void CreateTrimVideosDirectory() async
  {
    //This will get a directory path
    var dir=await getExternalStorageDirectory();


    //Check if Directory exists
    if(await Directory(dir.path+"/trimvideos").exists())
    {
      print("Directory exists");
    }
    else
    {
      //This function creates a directory
      var createDirectory =  await Directory(dir.path+"/trimvideos").create();
      print("Newly create downloaded directory is:"+createDirectory.path);
    }

    CreateSaveFinalVideosDirectory();

//    //This will sent to home page
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => Home()));



  }


  //Create Save Final Videos Directory
  void CreateSaveFinalVideosDirectory() async
  {
    //This will get a directory path
    var dir=await getExternalStorageDirectory();


    //Check if Directory exists
    if(await Directory(dir.path+"/savefinalvideos").exists())
    {
      print("Directory exists");
    }
    else
    {
      //This function creates a directory
      var createDirectory =  await Directory(dir.path+"/savefinalvideos").create();
      print("Newly create downloaded directory is:"+createDirectory.path);
    }

    //This will sent to home page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home()));

  }



}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting)
        //   return FullScreenLoader();
        if (!snapshot.hasData || snapshot.data == null) return Login();
        return Home();
      },
    );
  }
}
