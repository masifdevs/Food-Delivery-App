class CustomerNotification {
  final int id;
  final String title;
  final String description;
  final String date;

  CustomerNotification({
    this.id,
    this.title,
    this.description,
    this.date,
  });
  factory CustomerNotification.fromJson(Map<String, dynamic> jsonData) {
    return CustomerNotification(
      id: int.parse(jsonData['Noti_id']),
      title: jsonData['title'],
      description: (jsonData['description']),
      date: (jsonData['date']),
    );
  }
}
