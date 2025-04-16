
class AppNotification {
  final String name;
  final String content;
final int userId;
  final String date;

  AppNotification({
    required this.name,
    required this.content,
required this.userId,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'content': content,
        'user_id': 1,
        'date': date,
      };
}
