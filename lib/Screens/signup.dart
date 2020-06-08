import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_application/Screens/login.dart';
import 'package:music_application/widgets/fullscreenloader.dart';
import 'package:music_application/widgets/textformfield.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../global.dart';
import '../theme.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  bool passwordVisibleSignUp = false;
  bool passwordVisibleSignUpConfirm = false;

  Function onPressedSignUp() {
    setState(() {
      passwordVisibleSignUp = !passwordVisibleSignUp;
    });
  }

  Function onPressedConfirm() {
    setState(() {
      passwordVisibleSignUp = !passwordVisibleSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: _buildBody(context),
        ),
        _isLoading ? FullScreenLoader() : Container()
      ],
    );
  }

  SafeArea _buildBody(BuildContext context) {
    return SafeArea(
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
                    child: Image(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 2,
                      image: AssetImage(
                        SplashScreenConfig.logoAssetName,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  Flexible(
                    flex: 2,
                    child: Form(
                      autovalidate: _autoValidate,
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //     left: AppPadding.formFieldPadding[0],
                          //     right: AppPadding.formFieldPadding[0],
                          //     top: AppPadding.formFieldPadding[0],
                          //   ),
                          //   child: MusicTextFormField(
                          //     keyboardType: TextInputType.text,
                          //     obscureText: false,
                          //     controller: nameController,
                          //     hintText: 'Enter Your Name',
                          //     validatorFunction: (String text) {
                          //       if (text.isEmpty) {
                          //         return '*Required';
                          //       }
                          //     },
                          //   ),
                          // ),

                          Padding(
                            padding: EdgeInsets.only(
                              left: AppPadding.formFieldPadding[0],
                              right: AppPadding.formFieldPadding[0],
                              top: 10,
                            ),
                            child: MusicTextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              hintText: 'Enter Your Email',
                              validatorFunction: (String text) {
                                if (text.isEmpty) {
                                  return '*Required';
                                }
                              },
                              isPassField: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: AppPadding.formFieldPadding[0],
                              right: AppPadding.formFieldPadding[0],
                              top: 10,
                            ),
                            child: MusicTextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passController,
                              hintText: 'Enter Your Password',
                              validatorFunction: (String text) {
                                if (text.isEmpty) {
                                  return '*Required';
                                }
                              },
                              isPassField: true,
                              isPasswordVisible: passwordVisibleSignUp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: AppPadding.formFieldPadding[0],
                              right: AppPadding.formFieldPadding[0],
                              top: 10,
                              bottom: 10,
                            ),
                            child: MusicTextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPassController,
                              hintText: 'Re-enter our Password',
                              validatorFunction: (text) {
                                if (text.isEmpty) {
                                  return '*Required';
                                } else if (text != passController.text)
                                  {
                                    return 'Password is not match';
                                  }
//                                  Alert(
//                                    context: context,
//                                    type: AlertType.error,
//                                    title: "Error",
//                                    desc: "Password is not match",
//                                    buttons: [
//                                      DialogButton(
//                                        child: Text("DISMISS",
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .title
//                                                .copyWith(
//                                                  color: Colors.white,
//                                                )),
//                                        color: theme.accentColor,
//                                        onPressed: () {
//                                          Navigator.of(context).pop();
//                                        },
//                                      )
//                                    ],
//                                  ).show();
                                return null;
                              },
                              isPassField: true,
                              isPasswordVisible: passwordVisibleSignUp,
                            ),
                          ),
                          MaterialButton(
                            height: MediaQuery.of(context).size.width / 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: theme.primaryColor),
                            ),
                            color: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                // Firestore.instance
                                //     .collection('MusicApplication')
                                //     .document()
                                //     .setData({
                                //   'Email': emailController,
                                //   'Name': nameController
                                // });
                                // setState(() {});
                                // await FirebaseAuth.instance
                                //     .createUserWithEmailAndPassword(
                                //         email: emailController.text,
                                //         password: passController.text)
                                //     .then((_) {})
                                //     .catchError(() {});
                                signUp();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ]),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            )),
      ),
    );
  }

  void signUp() async {
    try {
      setState(() {
        _isLoading = true;
      });
      FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passController.text))
          .user;

      setState(() {
        _isLoading = false;
      });
      user.sendEmailVerification();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
}
