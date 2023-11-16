import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkButton extends StatelessWidget {
  final String url;

  const LinkButton({super.key, required this.url});

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Não foi possível lançar $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchUrl,
      child: const Text('Visão analítica'),
    );
  }
}
