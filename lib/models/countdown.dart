class CountDown {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  CountDown({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  static CountDown fromMap(Map<String, dynamic> map) {
    return CountDown(
      id: map['id'],
      title: map['title'],
      endDate: DateTime.parse(map['endDate']),
      startDate: DateTime.parse(map['startDate']),
    );
  }
}
