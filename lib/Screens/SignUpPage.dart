import 'package:firebase/services/GoogleSignIn.dart';
import 'package:firebase/Screens/LoginPage.dart';
import 'package:firebase/Screens/mainPage.dart';
import 'package:firebase/services/OtpLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscureText = true;
  User? user;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // Sign Up with Email and Password
  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      user = userCredential.user; 

      print("User signed up: ${userCredential.user?.email}");

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('User signed up successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to MainPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PhoneAuthPage(email: email, )) ,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Show error dialog when an exception occurs
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.message ?? "An unknown error occurred"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  
// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: scopes,
//   clientId: '473449169642-scrdg5m187bsahle2n333abirhstt2f6.apps.googleusercontent.com' ,
// );

//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//       // After successful sign-in, navigate to MainPage
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
//       );
//     } catch (error) {
//       print(error);
//       // Handle the sign-in error
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Sign In Error'),
//             content: Text(error.toString()),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.blueGrey[300],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _username,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                labelText: "Username",
                border: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                labelText: "Email",
                hintText: "abc@gmail.com",
                border: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _password,
              obscureText: _obscureText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                labelText: "Password",
                border: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = _email.text.trim();
                final password = _password.text.trim();
                signUpWithEmailPassword(email, password);
              },
              child: const Text('Sign Up'),
            ),
            SizedBox(height: 21), 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                );
              },
              child: const Text("Go to Login Page"),
            ),
            SizedBox(height: 21), 

            // ElevatedButton(
            //   onPressed: ()  {
            //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PhoneAuthPage(email: email,) ) ) ;
            //   },
            //   child: const Text("Sign In with OTP"),
            // ),

          ],
        ),
      ),
    );
  }
}
