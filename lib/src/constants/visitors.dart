class Visitors {
  final String id;
  final String fullname;
  final String reasonV;
  final String timeIn;
  final String timeOut;
  final String condoOwner;
  final String condoNumber;
  final String visit_id;
  final String image;

  Visitors({
    required this.id,
    required this.fullname,
    required this.reasonV,
    required this.timeIn,
    required this.timeOut,
    required this.condoOwner,
    required this.condoNumber,
    required this.visit_id,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'reasonV': reasonV,
        'timeIn': timeIn,
        'timeOut': timeOut,
        'condoOwner': condoOwner,
        'condoNumber': condoNumber,
        'visit_id': visit_id,
        'image': image,
      };

  static Visitors fromJson(Map<String, dynamic> json) => Visitors(
        id: json['id'],
        fullname: json['fullname'],
        reasonV: json['reasonV'],
        timeIn: json['timeIn'],
        timeOut: json['timeOut'],
        condoOwner: json['condoOwner'],
        condoNumber: json['condoNumber'],
        visit_id: json['visit_id'],
        image: json['image'],
      );
}
