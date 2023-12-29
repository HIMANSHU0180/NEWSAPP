import 'package:flutter/material.dart';
import 'news_detail_screen.dart';
import 'news_search_delegate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'article.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String apiKey = '85940a4d7b23488ba7ecd9e9e7c6533e'; // Replace with your own API key
  String country = 'us';
  TextEditingController searchController = TextEditingController();
  List<Article> allNews = [];
  List<Article> news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<List<Article>> fetchNews({String query = ''}) async {
    try {
      final apiUrl =
          'https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apiKey&q=$query';


      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> articles = data['articles'];
        allNews = [];
        for (int i = 0; i < articles.length; i++) {
          allNews.add(Article.fromJson(articles[i]));
        }

        setState(() {
          news = _filterNews(allNews, query);
        });
        return news;
      } else {
        throw Exception('Failed to load news. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  List<Article> _filterNews(List<Article> allNews, String query) {
    List<Article> filteredNews = [];
    for (int i = 0; i < allNews.length; i++) {
      if (allNews[i].title.toLowerCase().contains(query.toLowerCase())) {
        filteredNews.add(allNews[i]);
      }
    }
    print('Filtered News: $filteredNews');
    return filteredNews;
  }

  Widget _buildCountrySelector() {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      child: DropdownButton<String>(
        value: country,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.white),
        underline: Container(
          height: 2,
          color: Colors.white,
        ),
        onChanged: (String? newValue) {
          setState(() {
            country = newValue!;
          });
          fetchNews();
        },
        items: <String>['us', 'gb', 'in']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNewsList() {
    if (news.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(8),
            color: Colors.blueGrey,
            child: ListTile(
              title: Text(
                news[index].title,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                news[index].description,
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(article: news[index]),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(fetchNews: fetchNews),
              );
            },
          ),
          _buildCountrySelector(),
        ],
      ),
      body: _buildNewsList(),
    );
  }
}
