class Event {
  final int id;
  final String title;
  final String content;
  final DateTime date;
  final String link;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.link,
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title']['rendered'] ?? '',
      content: json['content']['rendered'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      link: json['link'] ?? '',
      imageUrl: json['_links']['wp:featuredmedia']?[0]['href'] ?? '',
    );
  }
}
