import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nexus_app/data/model/attendance_model.dart';
import 'package:nexus_app/data/repository/attendance_repository.dart';
import 'package:flutter/material.dart';

class AttendanceController extends GetxController {
  final repo = AttendanceRepository();

  var currentTime = "".obs;
  var currentDate = "".obs;
  var attendanceStatus = "Not Marked".obs;
  var isCheckedIn = false.obs;
  var history = <AttendanceModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
    fetchHistory();
  }

  void updateDateTime() {
    currentDate.value = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    Stream.periodic(const Duration(seconds: 1)).listen((_) {
      currentTime.value = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  void fetchHistory() async {
    isLoading.value = true;
    history.value = await repo.getAttendanceHistory();
    isLoading.value = false;
  }

  Future<void> markAttendance(bool checkIn) async {
    isLoading.value = true;
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Disabled", "Please enable location services.", 
          backgroundColor: Colors.orange.withOpacity(0.1));
        isLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission Denied", "Location permissions are required.",
            backgroundColor: Colors.red.withOpacity(0.1));
          isLoading.value = false;
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      
      // Office Location (Mock: Bangalore center)
      double officeLat = 12.9716;
      double officeLong = 77.5946;
      
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, officeLat, officeLong
      );

      // Allowing a wider range for testing (10km) - normally it would be 50-100m
      if (distanceInMeters > 10000) { 
        Get.defaultDialog(
          title: "Out of Range",
          middleText: "You are too far from the office to mark attendance.",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(),
        );
        isLoading.value = false;
        return;
      }

      Map<String, dynamic> data = {
        "userId": 1,
        "title": checkIn ? "Check-In" : "Check-Out",
        "body": "Location: ${position.latitude}, ${position.longitude}",
      };

      bool success = await repo.markAttendance(data);

      if (success) {
        isCheckedIn.value = checkIn;
        attendanceStatus.value = checkIn ? "Present (Checked In)" : "Checked Out";
        Get.snackbar("Success", checkIn ? "Checked In Successfully" : "Checked Out Successfully",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.green.withOpacity(0.1));
        fetchHistory();
      } else {
        Get.snackbar("Error", "Failed to sync with server", backgroundColor: Colors.red.withOpacity(0.1));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
