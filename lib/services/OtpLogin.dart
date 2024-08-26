import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/Screens/ProfilePage.dart';

class PhoneAuthPage extends StatefulWidget {
  final String email ;

   PhoneAuthPage({required this.email, super.key});

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';
  bool _isOtpSent = false;

  // Function to initiate phone number verification
  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_phoneController.text}', // Add country code
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto verification case (instant)
        await _auth.signInWithCredential(credential);
        _navigateToProfilePage(_phoneController.text.trim());
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  // Function to sign in using the OTP entered by the user
  void _verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      _navigateToProfilePage(_phoneController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
      );
    }
  }

  // Function to navigate to the Profile Page after successful OTP verification
  void _navigateToProfilePage( String phoneNumber ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(email: widget.email , phoneNumber: phoneNumber,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 26),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _verifyPhoneNumber,
              child: Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
