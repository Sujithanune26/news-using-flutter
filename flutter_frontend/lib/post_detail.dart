import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final Map post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post["title"]),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (if exists)
            if (post["image"] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(post["image"]),
              ),

            const SizedBox(height: 16),

            // Title
            Text(
              post["title"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Content (raw HTML text for now)
            Text(
              post["content"].replaceAll(
                RegExp(r'<[^>]*>'),
                '',
              ), // remove HTML tags
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
