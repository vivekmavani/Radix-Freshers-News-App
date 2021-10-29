import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:radix_freshers/common_widgets/show_exception_alert_dialog.dart';
import 'package:radix_freshers/services/auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return SignInPage();
  }

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      exception: exception,
      title: 'Sign in Failed',
    );
  }

  Future<void> _signinWithGoogle(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final auth = Provider.of<AuthBase>(context, listen: false);
      final userc = await auth.signInWithGoogle();
      print("what ${userc!.uid}");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      _showSignInError(context, e);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radix Freshers'),
        elevation: 2.0,
      ),
      body: _bodyContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _bodyContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0, child: _buildHeader()),
            SignInButton(
            Buttons.Google,
            text: "Sign up with Google",
            onPressed: isLoading ? (){} : ()=>_signinWithGoogle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if(isLoading)
    {
      return  const Center(child: CircularProgressIndicator());
    }
    return  const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
