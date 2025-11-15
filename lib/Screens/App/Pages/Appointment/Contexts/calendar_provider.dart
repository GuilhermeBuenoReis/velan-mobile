import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Contexts/calendar_context.dart';
import 'package:provider/provider.dart';

class CalendarProvider extends StatelessWidget {
  final Widget child;

  const CalendarProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarController(),
      child: child,
    );
  }
}

CalendarController calendarOf(BuildContext context, {bool listen = true}) {
  return Provider.of<CalendarController>(context, listen: listen);
}
