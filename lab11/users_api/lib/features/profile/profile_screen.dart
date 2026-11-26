import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  final ImagePicker _picker = ImagePicker();

  File? _photo;

  bool _busy = false;

  @override
  void initState() {
    super.initState();

    unawaited(_restorePhoto());

    if (Platform.isAndroid) {
      unawaited(_recoverLostImage());
    }
  }

  Future<void> _restorePhoto() async {
    try {
      final path = await _prefs.getString('avatarPath');

      if (path == null) return;

      final file = File(path);

      if (await file.exists() && mounted) {
        setState(() {
          _photo = file;
        });
      }
    } catch (error) {
      _message('Could not restore photo: $error');
    }
  }

  Future<void> _recoverLostImage() async {
    try {
      final lost = await _picker.retrieveLostData();

      if (lost.isEmpty) return;

      final images = lost.files;

      if (images != null && images.isNotEmpty) {
        await _saveImage(images.first);
      }
    } catch (error) {
      _message('Could not restore picked image: $error');
    }
  }

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _saveImage(XFile picked) async {
    final directory = await getApplicationDocumentsDirectory();

    final destination = File('${directory.path}/avatar.jpg');

    await File(picked.path).copy(destination.path);

    // Refresh a previously cached image.
    await FileImage(destination).evict();

    await _prefs.setString('avatarPath', destination.path);

    if (!mounted) return;

    setState(() {
      _photo = destination;
    });

    _message('Profile photo saved');
  }

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;

    setState(() {
      _busy = true;
    });

    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );

      // Cancel is not an error.
      if (picked == null || !mounted) {
        return;
      }

      await _saveImage(picked);
    } catch (error) {
      _message('Photo failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    // Ask for camera permission only after a tap.
    final status = await Permission.camera.request();

    if (!mounted) return;

    if (status.isGranted) {
      await _pick(ImageSource.camera);
    } else if (status.isPermanentlyDenied) {
      await _showSettingsDialog();
    } else if (status.isDenied) {
      _message(
        'Camera permission denied. '
        'You can try again.',
      );
    } else if (status.isRestricted) {
      _message('Camera is restricted by device settings.');
    } else if (status.isLimited || status.isProvisional) {
      _message('Camera permission is not fully granted.');
    } else {
      _message('Camera permission unavailable.');
    }
  }

  Future<void> _showSettingsDialog() async {
    final open = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Camera access blocked'),
        content: const Text(
          'Camera permission was denied '
          'permanently. Please enable it '
          'in the app settings.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Cancel'),
          ),

          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );

    if (open != true || !mounted) {
      return;
    }

    final success = await openAppSettings();

    if (!success) {
      _message('Could not open system settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photo;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 65,
              backgroundImage: photo == null ? null : FileImage(photo),
              child: photo == null
                  ? const Text('U', style: TextStyle(fontSize: 42))
                  : null,
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Your profile photo is stored '
            'in Documents, not Temporary.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

          FilledButton.icon(
            onPressed: _busy ? null : () => _pick(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choose photo'),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: _busy ? null : _takePhoto,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Take photo'),
          ),

          if (_busy) ...<Widget>[
            const SizedBox(height: 18),

            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
