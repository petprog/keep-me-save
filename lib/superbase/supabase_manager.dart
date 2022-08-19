import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:keep_me_save/common/toast.dart';

const String supabaseUrl = "https://ostsvckxgnmxkikexcrs.supabase.co ";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9zdHN2Y2t4Z25teGtpa2V4Y3JzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjA5Mjk4NTgsImV4cCI6MTk3NjUwNTg1OH0.vJUjKi0B8l_fKxLEZRYR06dF3dl6EAvV7OtBVrUhZxU";

class SupabaseManager {
  final client = SupabaseClient(supabaseUrl, token);

  Future<void> signUpUser(context, {String? email, String? password}) async {
    debugPrint("email:$email password:$password");
    final result = await client.auth.signUp(email!, password!);

    debugPrint(result.data!.toJson().toString());

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
    debugPrint(result.data!.toJson().toString());

    if (result.data != null) {
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
    Navigator.pushReplacementNamed(context, 'login');
  }
}
