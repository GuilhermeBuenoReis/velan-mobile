import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Contexts/calendar_provider.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Widgets/calendar_header.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Widgets/day_view.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Widgets/event_details_modal.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Widgets/month_view.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Widgets/new_appointment_modal.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Widgets/week_view.dart';
import 'package:velan_mobile/Screens/App/Pages/Appointment/Widgets/year_view.dart';
import 'package:velan_mobile/Screens/App/app_layout.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarProvider(
      child: AppLayout(
        breadcrumbs: const ['Consultas'],
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () =>
                calendarOf(context, listen: false).openCreateModal(),
            icon: const Icon(Icons.add),
            label: const Text('Nova consulta'),
          ),
        ),
        child: const _AppointmentBody(),
      ),
    );
  }
}

class _AppointmentBody extends StatelessWidget {
  const _AppointmentBody();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final controller = calendarOf(context);
        return ColoredBox(
          color: const Color(0xFF0F0F0F),
          child: SafeArea(
            child: Stack(
              children: [
                _ResponsiveCalendar(),
                Align(
                  alignment: Alignment.center,
                  child: EventDetailsModal(
                    event: controller.selectedEvent,
                    isOpen: controller.isEventDetailsOpen,
                    onClose: controller.closeEventDetails,
                    onEdit: controller.selectedEvent == null
                        ? null
                        : () => controller.openEditModal(
                              controller.selectedEvent!,
                            ),
                    onDelete: controller.selectedEvent == null
                        ? null
                        : () => controller.deleteEvent(
                              controller.selectedEvent!,
                            ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: NewAppointmentModal(
                    isOpen: controller.isCreateModalOpen,
                    close: controller.closeCreateModal,
                    onSubmit: controller.submitAppointment,
                    draftEventDate: controller.draftEventDate,
                    userId: controller.userId,
                    initialEvent: controller.editingEvent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResponsiveCalendar extends StatelessWidget {
  const _ResponsiveCalendar();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 720;
        final baseHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 640.0;
        final compactHeight = baseHeight.clamp(360.0, 720.0).toDouble();

        final header = <Widget>[
          const SizedBox(height: 24),
          const Text(
            'Consultas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Gerencie, edite e acompanhe seus agendamentos em tempo real',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFBDBDBD),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          const _CalendarHeaderWrapper(),
          const SizedBox(height: 16),
        ];

        if (isCompact) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...header,
                    SizedBox(
                      height: compactHeight,
                      child: const _CalendarContent(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                ...header,
                Expanded(
                  child: const _CalendarContent(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _CalendarHeaderWrapper extends StatelessWidget {
  const _CalendarHeaderWrapper();

  @override
  Widget build(BuildContext context) {
    final controller = calendarOf(context);

    return CalendarHeader(
      currentDate: controller.currentDate,
      currentView: controller.currentView,
      goPrevious: controller.goPrevious,
      goNext: controller.goNext,
      goToday: controller.goToday,
      setView: controller.setView,
      isLoading: controller.isLoading,
    );
  }
}

class _CalendarContent extends StatelessWidget {
  const _CalendarContent();

  @override
  Widget build(BuildContext context) {
    final controller = calendarOf(context);

    switch (controller.currentView) {
      case 'day':
        return DayView(
          currentDate: controller.currentDate,
          events: controller.events,
          isLoading: controller.isLoading,
          openEventModal: controller.openEventDetails,
        );
      case 'week':
        return WeekView(
          currentDate: controller.currentDate,
          events: controller.events,
          openEventModal: controller.openEventDetails,
        );
      case 'year':
        return YearView(
          currentDate: controller.currentDate,
          events: controller.events,
          setDate: controller.setDate,
          clearSelectedEvent: controller.closeEventDetails,
          setView: controller.setView,
          openEventModal: controller.openEventDetails,
        );
      case 'month':
      default:
        return MonthView(
          currentDate: controller.currentDate,
          events: controller.events,
          openEventModal: controller.openEventDetails,
          setDate: controller.setDate,
        );
    }
  }
}
