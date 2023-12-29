import 'package:flutter/material.dart';
import 'article.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: Image.network(
              article.urlToImage ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                print('Stack trace: $stackTrace');
                return Container(); // Placeholder or empty container when there's an error
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              article.description,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
