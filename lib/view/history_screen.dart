import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/attendance_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendanceController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Attendance Log", 
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, color: isDark ? Colors.white : Colors.blue.shade900)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.cardColor,
        foregroundColor: isDark ? Colors.white : Colors.blue.shade900,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Weekly Summary Row
          Container(
            padding: const EdgeInsets.all(20),
            color: theme.cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem(context, "Present", "18", Colors.green),
                _summaryItem(context, "Late", "02", Colors.orange),
                _summaryItem(context, "Absent", "01", Colors.red),
              ],
            ),
          ),
          
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemCount: controller.history.length,
                itemBuilder: (context, index) {
                  final item = controller.history[index];
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.02), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(width: 8, color: _getStatusColor(item.status)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.date, 
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(item.status).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            item.status.toUpperCase(),
                                            style: TextStyle(
                                              color: _getStatusColor(item.status), 
                                              fontSize: 10, 
                                              fontWeight: FontWeight.w900
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        _timeBadge(context, Icons.login_rounded, item.checkIn ?? "--:--", Colors.green),
                                        const SizedBox(width: 20),
                                        _timeBadge(context, Icons.logout_rounded, item.checkOut ?? "--:--", Colors.red),
                                        const Spacer(),
                                        Text("8h 30m", style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(BuildContext context, String label, String count, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color)),
      ],
    );
  }

  Widget _timeBadge(BuildContext context, IconData icon, String time, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(time, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Present":
      case "Present (Checked In)": return Colors.green.shade600;
      case "Late Entry": return Colors.orange.shade600;
      case "Half Day": return Colors.blue.shade600;
      case "Absent": return Colors.red.shade600;
      default: return Colors.grey;
    }
  }
}
