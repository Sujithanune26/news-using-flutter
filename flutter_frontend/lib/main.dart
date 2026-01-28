import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'post_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostsPage(),
    );
  }
}

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List posts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse("http://127.0.0.1:5000/posts");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          posts = json.decode(response.body);
          loading = false;
        });
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        backgroundColor: Colors.deepPurple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.article),
                    title: Text(post["title"]),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    // ✅ THIS IS THE IMPORTANT PART
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
