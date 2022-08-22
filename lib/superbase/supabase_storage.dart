import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/toast.dart';

class SupabaseStorage {
  final client = Supabase.instance.client;

  Future<void> uploadFile(File file) async {
    final storageResponse =
        await client.storage.from('public').upload('new_file.txt', file);
    if (storageResponse.error != null) {
      showToastMessage(storageResponse.error!.message, isError: true);
    }
  }

  Future<void> downloadFile(File file) async {
    final storageResponse =
        await client.storage.from('public').download('new_file.txt');
  }
}
