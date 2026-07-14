class AttendanceModel {
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String status; // Present, Absent, Half Day, Late Entry

  AttendanceModel({
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: json['date'] ?? '',
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      status: json['status'] ?? 'Absent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'status': status,
    };
  }
}
