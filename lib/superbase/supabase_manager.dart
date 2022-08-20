import 'package:flutter/material.dart';
import 'package:keep_me_save/common/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../authentication/authentication.dart';

class SupabaseManager {
  final client = Supabase.instance.client;

  Future<void> signUpUser(context, {String? email, String? password}) async {
    debugPrint("email:$email password:$password");
    final result = await client.auth.signUp(
      email!,
      password!,
    );

    // debugPrint(result.data!.toJson().toString());

    if (result.data != null) {
      showToastMessage('Registration Success', isError: false);
      Navigator.pushReplacementNamed(context, 'login');
      showToastMessage('Success', isError: false);
    } else if (result.error?.message != null) {
      showToastMessage('Error:${result.error!.message.toString()}',
          isError: true);
    }
  }

  Future<void> signInUser(context, {String? email, String? password}) async {
    debugPrint("email:$email password:$password");
    final result = await client.auth.signIn(email: email!, password: password!);
    // debugPrint(result.data!.toJson().toString());

    if (result.data != null) {
      await Authentication().saveLogin();
      showToastMessage('Login Success', isError: false);
      Navigator.pushReplacementNamed(context, '/home');
      showToastMessage('Success', isError: false);
    } else if (result.error?.message != null) {
      showToastMessage('Error:${result.error!.message.toString()}',
          isError: true);
    }
  }

  Future<void> logout(context) async {
    await client.auth.signOut();
    final auth = Authentication();
    auth.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
