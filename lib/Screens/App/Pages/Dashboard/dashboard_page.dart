import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/App/Pages/Dashboard/widgets/exams_results.dart';
import 'package:velan_mobile/Screens/App/Pages/Dashboard/widgets/health_habits.dart';
import 'package:velan_mobile/Screens/App/Pages/Dashboard/widgets/health_overview.dart';
import 'package:velan_mobile/Screens/App/Pages/Dashboard/widgets/messages_panel.dart';
import 'package:velan_mobile/Screens/App/Pages/Dashboard/widgets/upcoming_appointments.dart';
import 'package:velan_mobile/Screens/App/app_layout.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      breadcrumbs: const ['Dashboard'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HealthOverview(),
            const SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: const [
                            UpcomingAppointments(),
                            SizedBox(height: 24),
                            HealthHabits(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: const [
                            MessagesPanel(),
                            SizedBox(height: 24),
                            ExamsResults(),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: const [
                    UpcomingAppointments(),
                    SizedBox(height: 24),
                    HealthHabits(),
                    SizedBox(height: 24),
                    MessagesPanel(),
                    SizedBox(height: 24),
                    ExamsResults(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
