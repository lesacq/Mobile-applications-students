import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final user = authVm.user;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: authVm.profileImageUrl != null
                      ? NetworkImage(authVm.profileImageUrl!)
                      : null,
                  child: authVm.profileImageUrl == null
                      ? Text(user?.email?.substring(0, 1).toUpperCase() ?? 'U')
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      final picker = await showModalBottomSheet<File?>(
                        context: context,
                        builder: (context) => _ImagePickerSheet(),
                      );
                      if (picker != null) {
                        await authVm.uploadProfilePicture(picker);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(user?.email ?? 'No email'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authVm.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}


class _ImagePickerSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
              Navigator.pop(context, picked != null ? File(picked.path) : null);
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.camera);
              Navigator.pop(context, picked != null ? File(picked.path) : null);
            },
          ),
        ],
      ),
    );
  }
}
