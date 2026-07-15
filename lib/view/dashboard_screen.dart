import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/attendance_controller.dart';
import 'package:nexus_app/view_model/controller/auth_controller.dart';
import 'package:nexus_app/view/history_screen.dart';
import 'package:nexus_app/view/profile_screen.dart';
import 'package:nexus_app/view/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const DashboardHome(),
    const HistoryScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.blue.shade900,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), label: "Log"),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: "User"),
              BottomNavigationBarItem(icon: Icon(Icons.tune_rounded), label: "More"),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final attendanceController = Get.put(AttendanceController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                      ? [const Color(0xFF1E1E1E), const Color(0xFF121212)] 
                      : [Colors.blue.shade900, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            "Hello, ${authController.user.value?.name.split(' ')[0] ?? 'User'}!",
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                          )),
                          const Text("Have a productive day!", style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Obx(() => Text(
                          attendanceController.currentTime.value,
                          style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                        )),
                        Obx(() => Text(
                          attendanceController.currentDate.value.toUpperCase(),
                          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Attendance Action", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  const SizedBox(height: 15),
                  
                  Obx(() {
                    bool isCheckedIn = attendanceController.isCheckedIn.value;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 15, offset: const Offset(0, 5))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _actionInfo(context, "Check In", isCheckedIn ? "09:00 AM" : "--:--", Icons.login, Colors.green),
                              Container(height: 40, width: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
                              _actionInfo(context, "Check Out", !isCheckedIn && attendanceController.attendanceStatus.value.contains("Checked Out") ? "06:00 PM" : "--:--", Icons.logout, Colors.red),
                            ],
                          ),
                          const SizedBox(height: 25),
                          
                          GestureDetector(
                            onTap: attendanceController.isLoading.value 
                              ? null 
                              : () => attendanceController.markAttendance(!isCheckedIn),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: attendanceController.isLoading.value 
                                  ? (isDark ? Colors.white10 : Colors.grey.shade300)
                                  : (isCheckedIn ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1)),
                                border: Border.all(
                                  color: isCheckedIn ? Colors.red : Colors.green,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isCheckedIn ? Colors.red : Colors.green).withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.touch_app, 
                                    size: 40, 
                                    color: isCheckedIn ? Colors.red : Colors.green
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isCheckedIn ? "CHECK OUT" : "CHECK IN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: isCheckedIn ? Colors.red : Colors.green
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.blue),
                              const SizedBox(width: 5),
                              Text("Office: Navrangpura, Ahmedabad",
                                style: TextStyle(color: isDark ? Colors.blue.shade300 : Colors.blue.shade800, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 25),
                  Text("Quick Stats", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  const SizedBox(height: 15),
                  
                  Row(
                    children: [
                      _statCard(context, "Working Hours", "08:45", Icons.timer, Colors.orange),
                      const SizedBox(width: 15),
                      _statCard(context, "Monthly Days", "22/26", Icons.calendar_month, Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionInfo(BuildContext context, String title, String time, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 5),
        Text(title, style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12)),
        Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
      ],
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            Text(title, style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
