import 'package:flutter/material.dart';

import 'property_detail_screen.dart';

class LiveCatalogPropertyScreen extends StatelessWidget {
  const LiveCatalogPropertyScreen({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context) => PropertyDetailScreen(slug: slug);
}
