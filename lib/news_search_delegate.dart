import 'package:flutter/material.dart';
import 'article.dart';
import 'news_detail_screen.dart';

class NewsSearchDelegate extends SearchDelegate<String> {
  final Future<List<Article>> Function({String query}) fetchNews;

  NewsSearchDelegate({required this.fetchNews});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: fetchNews(query: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<Article> searchResults = snapshot.data ?? [];
          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
                color: Colors.blueGrey,
                child: ListTile(
                  title: Text(
                    searchResults[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    searchResults[index].description,
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailScreen(article: searchResults[index]),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
