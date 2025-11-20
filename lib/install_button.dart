import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

import 'pwa_interop.dart';

class InstallButton extends StatefulWidget {
  const InstallButton({super.key});

  @override
  State<InstallButton> createState() => _InstallButtonState();
}

class _InstallButtonState extends State<InstallButton> {
  bool canInstall = false;

  @override
  void initState() {
    super.initState();

    web.window.addEventListener(
      'pwa-install-available',
          () {
        setState(() => canInstall = true);
      }.toJS,
    );
  }

  Future<void> _installPWA() async {
    await web.window.installPWA().toDart;
  }

  @override
  Widget build(BuildContext context) {
    if (!canInstall) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: _installPWA,
      child: const Text("Download the app"),
    );
  }
}