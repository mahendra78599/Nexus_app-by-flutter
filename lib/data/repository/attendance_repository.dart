import 'package:nexus_app/data/network/api_service.dart';
import '../model/attendance_model.dart';
import '../model/user_model.dart';

class AttendanceRepository {
  final ApiService api = ApiService();

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await api.get("users");
      return (response.data as List).map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> markAttendance(Map<String, dynamic> data) async {
    try {
      final response = await api.post("posts", data);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    // Mocking history since placeholder API doesn't have an attendance endpoint
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      AttendanceModel(date: "26 Oct 2023", checkIn: "09:02 AM", checkOut: "06:05 PM", status: "Present"),
      AttendanceModel(date: "25 Oct 2023", checkIn: "09:45 AM", checkOut: "06:00 PM", status: "Late Entry"),
      AttendanceModel(date: "24 Oct 2023", checkIn: "09:00 AM", checkOut: "01:30 PM", status: "Half Day"),
      AttendanceModel(date: "23 Oct 2023", status: "Absent"),
      AttendanceModel(date: "22 Oct 2023", checkIn: "08:55 AM", checkOut: "05:55 PM", status: "Present"),
    ];
  }
}
