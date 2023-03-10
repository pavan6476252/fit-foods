import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authservices = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medirec",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     authservices.signOut();
      //   },
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: authservices.status == AuthStatus.authenticated
              ? OtpVerificationScreen(authservices: authservices)
              : googleSignInButton(authservices: authservices),
        ),
      ),
    );
  }
}

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.authservices});
  final AuthService authservices;

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  TextEditingController _otpController = TextEditingController();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  String photoUrl = '';
  late bool newUser = false;

  @override
  void initState() {
    super.initState();
    newUser = widget.authservices.newUser;
    _nameController =
        TextEditingController(text: widget.authservices.user!.name ?? "");
    _emailController =
        TextEditingController(text: widget.authservices.user!.emailId ?? "");
    _phoneNumberController = TextEditingController(
        text: widget.authservices.user!.mobileNumber ?? "");
    photoUrl = widget.authservices.user!.photoUrl ?? "";
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _getOtp() async {
    await widget.authservices
        .verifyPhoneNumber('+91${_phoneNumberController.text.trim()}', context);
  }

  void _verifyOtp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String otp = _otpController.text;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.authservices.verificationString ?? '',
        smsCode: otp,
      );
      widget.authservices.verifCompl(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 60,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              enabled: !newUser,
              decoration: const InputDecoration(
                labelText: 'Email',
                // hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'OTP Verification',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),

            //verify otp
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile number',

                      // hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      _getOtp();
                    },
                    child: const Text("Get otp")),
              ],
            ),
           widget.authservices.otpField ? Column(children: [
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter OTP';
                  } else if (value.length < 6) {
                    return 'Please enter valid OTP';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter OTP',
                ),
              ),
              ElevatedButton(
                onPressed: ()=>_verifyOtp(context),
                child: const Text('Verify OTP'),
              ),
            ]) :const SizedBox()
          ],
        ));
  }
}

// Column(

//         children: [

//           const SizedBox(height: 16.0),

//           const SizedBox(height: 16.0),

//           ElevatedButton(
//             onPressed: () {
//               String name = _nameController.text;
//               // Do something with the user's name
//             },
//             child: const Text('Submit'),
//           ),
//         ],
//       ),

class googleSignInButton extends StatelessWidget {
  const googleSignInButton({
    super.key,
    required this.authservices,
  });

  final AuthService authservices;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // log a user in, letting all the listeners know
            authservices.signInWithGoogle(context);

            // context.go('/');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
