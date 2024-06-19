class VisitorsLog {
  final String id;

  VisitorsLog({
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  static VisitorsLog fromJson(Map<String, dynamic> json) => VisitorsLog(
        id: json['id'],
      );
}
