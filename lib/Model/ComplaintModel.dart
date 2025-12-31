class ComplaintModel {
  final int id;
  final String complaint;
  final String date;
  final String status;
  final List<dynamic> media;
  final String tourName;

  ComplaintModel({
    required this.id,
    required this.complaint,
    required this.date,
    required this.status,
    required this.media,
    required this.tourName,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id_complaint'],
      complaint: json['complaint'],
      date: json['complaint_date'],
      status: json['status'],
      media: json['media'] ?? [],
      tourName: json['tour']?['tour_name'] ?? "-",
    );
  }
}
