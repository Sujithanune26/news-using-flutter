from flask import Flask, jsonify
from flask_cors import CORS
import requests
import re



app = Flask(__name__)
CORS(app)

WP_BASE = "http://localhost/wordpress/wordpress/wp-json/wp/v2"

def get_featured_image(media_id):
    if media_id == 0:
        return None

    res = requests.get(f"{WP_BASE}/media/{media_id}")
    if res.status_code == 200:
        return res.json().get("source_url")
    return None

@app.route("/")
def home():
    return "Flask server is running 🚀"

@app.route("/posts", methods=["GET"])
def posts():
    res = requests.get(f"{WP_BASE}/posts")
    wp_posts = res.json()

    clean_posts = []

    for post in wp_posts:
        image_url = get_featured_image(post["featured_media"])

        # fallback: image inside content
        if image_url is None:
            image_url = extract_image_from_content(
                post["content"]["rendered"]
            )

        clean_posts.append({
            "id": post["id"],
            "title": post["title"]["rendered"],
            "content": post["content"]["rendered"],
            "date": post["date"],
            "image": image_url
        })

    return jsonify(clean_posts)

def get_featured_image(media_id):
    if media_id == 0:
        return None
    res = requests.get(f"{WP_BASE}/media/{media_id}")
    if res.status_code == 200:
        return res.json().get("source_url")
    return None

def extract_image_from_content(html):
    match = re.search(r'<img[^>]+src="([^">]+)"', html)
    if match:
        return match.group(1)
    return None

if __name__ == "__main__":
    app.run(debug=True)
