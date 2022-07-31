import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ruunr/main.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/signin";
  const SignInScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/images/logo.png"), width: 100),
              const SizedBox(height: 30),
              const Image(image: AssetImage("assets/images/logo_text.png"), width: 130),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {Navigator.pushNamed(context, SignUpScreen.routeName);}, 
                child: const Text("Sign Up"),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), minimumSize: const Size(150, 45), primary: const Color(0xffF8F9FA)),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {Navigator.pushNamed(context, LogInScreen.routeName);}, 
                child: const Text("Login", style: TextStyle(color: Color(0xffF8F9FA))),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), minimumSize: const Size(150, 45), primary: const Color(0xff212529), side: BorderSide(color: Color(0xffF8F9FA), width: 3)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  static String routeName = "/signup";
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signInFormKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String userPw = "";
  bool obscurePw = true;
  bool obscureCfmPw = true;
  String? errorEmail;
  String? errorPw;
  bool isLoading = false;
  String pattern = r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
  FocusNode fixFocus = FocusNode();


  void validateForm() {
    signInFormKey.currentState!.validate();
  }

  Future<void> saveForm() async {
    bool isValid = signInFormKey.currentState!.validate();
    errorEmail = null;
    errorPw = null;

    if (isValid) {
      signInFormKey.currentState!.save();
      fixFocus.unfocus();
      setState(() { isLoading = true; });
      // print({name, email, userPw});
      //https://firebase.google.com/docs/auth/flutter/password-auth#create_a_password-based_account
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: userPw);
        String uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection("users").doc(uid).set({"name": name, "email": email, "password": userPw, "account created": DateFormat("dd/MM/y").add_Hm().format(DateTime.now())});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account created successfully!")));
        setState(() { isLoading = false; });
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName, (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          setState(() { errorPw = "Weak Password!"; });
        } else if (e.code == "email-already-in-use") {
          setState(() { errorEmail = "Email taken!"; });
        } else if (e.code == "invalid-email") {
          setState(() { errorEmail = "Invalid email!"; });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red[400],));
        }
        setState(() { isLoading = false; });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red[400],));
      }
      // Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: GestureDetector(
        onTap: () { FocusScope.of(context).unfocus(); validateForm(); },
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 20, right: 20),
            children: [
              Form(
                key: signInFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      maxLength: 256,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name",
                        isDense: true,
                        prefixIcon: Icon(Icons.person, size: 24),
                        counterText: " "
                      ),
                      validator: (value) {
                        if (value == null || value == ""){
                          return "Cannot leave this empty!";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        name = value as String;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 256,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: errorEmail,
                        border: const OutlineInputBorder(),
                        labelText: "Email",
                        isDense: true,
                        prefixIcon: const Icon(Icons.mail, size: 24),
                        counterText:  " "
                      ),
                      validator: (value) {
                        if (value == null || value == ""){
                          return "Cannot leave this empty!";
                        } else if (!RegExp(pattern).hasMatch(value)) {
                          return "Invalid email!";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        email = value as String;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: obscurePw,
                      enableSuggestions: false,
                      autocorrect: false,
                      maxLength: 64,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {FocusScope.of(context).requestFocus(fixFocus);},
                      decoration: InputDecoration(
                        errorText: errorPw,
                        border: const OutlineInputBorder(),
                        labelText: "Password",
                        isDense: true,
                        prefixIcon: const Icon(Icons.password, size: 24),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePw = !obscurePw;
                            });
                          },
                          icon: Icon(obscurePw ? Icons.visibility : Icons.visibility_off)
                        )
                      ),
                      validator: (value) {
                        if (value == null || value == ""){
                          return "Cannot leave this empty!";
                        } else {
                          userPw = value;
                          return null;
                        }
                      },
                      onSaved: (value) {
                        // loc = value as String;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      focusNode: fixFocus,
                      obscureText: obscureCfmPw, //true be default
                      enableSuggestions: false,
                      autocorrect: false,
                      maxLength: 64,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        errorText: errorPw,
                        border: const OutlineInputBorder(),
                        labelText: "Confirm Password",
                        isDense: true,
                        prefixIcon: const Icon(Icons.password, size: 24),
                        counterText: " ",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureCfmPw = !obscureCfmPw;
                            });
                          },
                          icon: Icon(obscureCfmPw ? Icons.visibility : Icons.visibility_off)
                        )
                      ),
                      validator: (value) {
                        if (value == null || value == ""){
                          return "Cannot leave this empty!";
                        } else if (value != userPw) {
                          return "Password not match!";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        userPw = value as String;
                      },
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () { isLoading ? null : saveForm(); }, 
                      child: isLoading ? const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xff212529)))) : const Text("Sign Up"),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), minimumSize: const Size(150, 45), primary: const Color(0xffF8F9FA)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogInScreen extends StatefulWidget {
  static String routeName = "/login";
  const LogInScreen({ Key? key }) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final logInFormKey = GlobalKey<FormState>();
  String email = "";
  String userPw = "";
  bool obscurePw = true;
  String? errorEmail;
  String? errorPw;
  bool isLoading = false;
  String pattern = r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
  
  void validateForm() {
    logInFormKey.currentState!.validate();
  }

  Future<void> saveForm() async {
    bool isValid = logInFormKey.currentState!.validate();
    errorEmail = null;
    errorPw = null;

    if (isValid) {
      logInFormKey.currentState!.save();
      setState(() { isLoading = true; });
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: userPw);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successfully!")));
        setState(() { isLoading = false; });
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName, (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == "wrong-password") {
          setState(() { errorPw = "Incorrect Password!"; });
        } else if (e.code == "user-not-found") {
          setState(() { errorEmail = "No such user"; });
        } else if (e.code == "invalid-email") {
          setState(() { errorEmail = "Invalid email!"; });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red[400],));
        }
        setState(() { isLoading = false; });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: GestureDetector(
        onTap: () { FocusScope.of(context).unfocus(); validateForm(); },
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 20, right: 20),
            children: [
              Form(
                key: logInFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      maxLength: 256,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: errorEmail,
                        border: const OutlineInputBorder(),
                        labelText: "Email",
                        isDense: true,
                        prefixIcon: const Icon(Icons.mail, size: 24),
                        counterText:  " "
                      ),
                      validator: (value) {
                        if (value == null || value == ""){
                          return "Cannot leave this empty!";
                        } else if (!RegExp(pattern).hasMatch(value)) {
                          return "Invalid email!";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        email = value as String;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: obscurePw,
                      enableSuggestions: false,
                      autocorrect: false,
                      maxLength: 64,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        errorText: errorPw,
                        border: const OutlineInputBorder(),
                        labelText: "Password",
                        isDense: true,
                        prefixIcon: const Icon(Icons.password, size: 24),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePw = !obscurePw;
                            });
                          },
                          icon: Icon(obscurePw ? Icons.visibility : Icons.visibility_off)
                        )
                      ),
                       validator: (value) {
                        if (value == null || value == ""){
                          return "Cannot leave this empty!";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        userPw = value as String;
                      },
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () { isLoading ? null : saveForm(); }, 
                      child: isLoading ? const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xff212529)))) : const Text("Sign Up"),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), minimumSize: const Size(150, 45), primary: const Color(0xffF8F9FA)),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}