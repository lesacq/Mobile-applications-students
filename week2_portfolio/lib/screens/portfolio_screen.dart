import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../models/portfolio_data.dart';

class PortfolioScreen extends StatelessWidget {
  final PortfolioData data;

  const PortfolioScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Portfolio'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(name: data.name, title: data.title),
              SizedBox(height: 32),
            ],
          ),

        ),
      ),
    );
  }

}