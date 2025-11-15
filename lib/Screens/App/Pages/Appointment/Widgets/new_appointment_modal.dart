import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewAppointmentModal extends StatefulWidget {
  final bool isOpen;
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  final VoidCallback close;
  final String? draftEventDate;
  final int userId;
  final Map<String, dynamic>? initialEvent;

  const NewAppointmentModal({
    super.key,
    required this.isOpen,
    required this.onSubmit,
    required this.close,
    this.draftEventDate,
    this.userId = 1,
    this.initialEvent,
  });

  @override
  State<NewAppointmentModal> createState() => _NewAppointmentModalState();
}

class _NewAppointmentModalState extends State<NewAppointmentModal> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController dateController;
  late final TextEditingController timeController;
  late final TextEditingController locationController;
  late final TextEditingController doctorController;
  late final TextEditingController notesController;

  String duration = '60';
  String eventType = 'blue';
  bool isSubmitting = false;

  final List<Map<String, String>> durationOptions = [
    {'value': '30', 'label': '30 minutos'},
    {'value': '60', 'label': '1 hora'},
    {'value': '90', 'label': '1h 30min'},
    {'value': '120', 'label': '2 horas'},
    {'value': '180', 'label': '3 horas'},
  ];

  final List<Map<String, dynamic>> eventTypes = [
    {'value': 'blue', 'label': 'Consulta normal', 'color': Colors.blue},
    {'value': 'purple', 'label': 'Internação', 'color': Colors.purple},
    {'value': 'orange', 'label': 'Urgente', 'color': Colors.orange},
    {'value': 'red', 'label': 'Cancelado', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    locationController = TextEditingController();
    doctorController = TextEditingController();
    notesController = TextEditingController();
    _setInitialFormValues(rebuild: false);
  }

  @override
  void didUpdateWidget(covariant NewAppointmentModal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.isOpen && !oldWidget.isOpen) ||
        widget.initialEvent != oldWidget.initialEvent) {
      formKey.currentState?.reset();
      _setInitialFormValues();
    } else if (widget.isOpen &&
        widget.initialEvent == null &&
        widget.draftEventDate != null &&
        widget.draftEventDate != oldWidget.draftEventDate) {
      dateController.text = widget.draftEventDate!;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    locationController.dispose();
    doctorController.dispose();
    notesController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.initialEvent != null;

  void _setInitialFormValues({bool rebuild = true}) {
    final data = widget.initialEvent;
    final selectedDate =
        data?['date'] ??
        widget.draftEventDate ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    titleController.text = data?['title'] ?? data?['Título'] ?? '';
    dateController.text = selectedDate;
    timeController.text =
        data?['start_time'] ??
        data?['Horário de início'] ??
        _timeFromEvent(data);
    locationController.text = data?['location'] ?? data?['Localização'] ?? '';
    doctorController.text = data?['doctor'] ?? data?['Médico'] ?? '';
    notesController.text = data?['notes'] ?? data?['Nota'] ?? '';

    final desiredDuration =
        (data?['durationMinutes'] ?? data?['Duração em minutos'] ?? 60)
            .toString();
    final desiredEventType =
        data?['event_type'] ??
        data?['Tipo de evento'] ??
        data?['color'] ??
        'blue';

    void assignValues() {
      duration = durationOptions.any((d) => d['value'] == desiredDuration)
          ? desiredDuration
          : durationOptions.first['value']!;
      eventType = eventTypes.any((e) => e['value'] == desiredEventType)
          ? desiredEventType
          : 'blue';
    }

    if (rebuild && mounted) {
      setState(assignValues);
    } else {
      assignValues();
    }
  }

  String _timeFromEvent(Map<String, dynamic>? data) {
    if (data == null) return '09:00';
    if (data['start_time'] is String &&
        (data['start_time'] as String).isNotEmpty) {
      return data['start_time'] as String;
    }
    final hour = data['startHour'];
    final minute = data['startMinute'];
    if (hour is num && minute is num) {
      final h = hour.toInt().toString().padLeft(2, '0');
      final m = minute.toInt().toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '09:00';
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final normalizedDate = _normalizeDate(dateController.text.trim());
    if (normalizedDate == null) {
      _showSnack('Informe uma data válida no formato AAAA-MM-DD.');
      return;
    }

    final normalizedTime = _normalizeTime(timeController.text.trim());
    if (normalizedTime == null) {
      _showSnack('Informe um horário válido no formato HH:MM.');
      return;
    }

    final durationMinutes = int.tryParse(duration);
    if (durationMinutes == null || durationMinutes <= 0) {
      _showSnack('Selecione uma duração válida.');
      return;
    }

    final payload = {
      'user_id': widget.userId,
      'title': titleController.text.trim(),
      'date': normalizedDate,
      'start_time': normalizedTime,
      'duration': durationMinutes,
      'event_type': eventType,
      'location': locationController.text.trim(),
      'doctor': doctorController.text.trim(),
      'notes': notesController.text.trim(),
    };

    setState(() => isSubmitting = true);

    try {
      await widget.onSubmit(payload);
      if (!mounted) return;
      _showSnack(
        isEditing
            ? 'Consulta atualizada com sucesso.'
            : 'Consulta criada com sucesso.',
        success: true,
      );
      widget.close();
    } on DioException catch (error) {
      if (!mounted) return;
      _showSnack(_mapDioError(error));
    } catch (_) {
      if (!mounted) return;
      _showSnack(
        'Não foi possível salvar a consulta. Detalhes semelhantes foram enviados anteriormente?',
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  String? _normalizeDate(String raw) {
    if (raw.isEmpty) return null;
    final sanitized = raw.replaceAll('/', '-');
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(sanitized)) {
      return sanitized;
    }

    final brMatch = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(sanitized);
    if (brMatch != null) {
      final day = brMatch.group(1);
      final month = brMatch.group(2);
      final year = brMatch.group(3);
      return '$year-$month-$day';
    }

    try {
      final parsed = DateTime.parse(raw);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      return null;
    }
  }

  String? _normalizeTime(String raw) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(raw);
    if (match == null) return null;
    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  void _showSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : null,
      ),
    );
  }

  String _mapDioError(DioException error) {
    final response = error.response;
    if (response != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final errors = data['errors'];
        if (errors is Map) {
          for (final entry in errors.entries) {
            final value = entry.value;
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
            if (value is String && value.isNotEmpty) {
              return value;
            }
          }
        }
        if (data['message'] is String &&
            (data['message'] as String).isNotEmpty) {
          return data['message'] as String;
        }
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tempo de conexão esgotado. Verifique sua internet.';
      case DioExceptionType.connectionError:
        return 'Não foi possível se conectar ao servidor. Tente novamente.';
      default:
        return 'Erro ao salvar a consulta. Revise os dados e tente novamente.';
    }
  }

  Widget _buildResponsiveFieldGroup(List<Widget> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 500;
        final isStacked = maxWidth < 420;
        final fieldWidth = isStacked ? maxWidth : (maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: fields
              .map(
                (field) => SizedBox(width: fieldWidth as double, child: field),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();
    final c = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context).size;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: media.height * .9,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardPadding),
          child: Container(
            padding: const EdgeInsets.all(24),
            color: c.surface,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? "Edit Appointment"
                                  : "New Appointment",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: c.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isEditing
                                  ? "Atualize os dados da consulta selecionada."
                                  : "Informe os detalhes para criar uma nova consulta.",
                              style: TextStyle(
                                fontSize: 13,
                                color: c.onSurface.withValues(alpha: .7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Fechar',
                        onPressed: isSubmitting
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                widget.close();
                              },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title *"),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? "Título é obrigatório"
                        : null,
                  ),

                  const SizedBox(height: 16),

                  _buildResponsiveFieldGroup([
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Date *"),
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Data é obrigatória"
                          : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Start Time *",
                      ),
                      controller: timeController,
                      keyboardType: TextInputType.datetime,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Horário é obrigatório"
                          : null,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _buildResponsiveFieldGroup([
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Duration *",
                      ),
                      value: duration,
                      items: durationOptions
                          .map<DropdownMenuItem<String>>(
                            (Map<String, String> d) => DropdownMenuItem<String>(
                              value: d['value']!,
                              child: Text(d['label']!),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => duration = value ?? duration),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Event Type *",
                      ),
                      value: eventType,
                      items: eventTypes
                          .map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> e) =>
                                DropdownMenuItem<String>(
                                  value: e['value'] as String,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: e['color'] as Color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(e['label'] as String),
                                    ],
                                  ),
                                ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => eventType = value ?? eventType),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  TextFormField(
                    decoration: const InputDecoration(labelText: "Location"),
                    controller: locationController,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Doctor / Provider",
                    ),
                    controller: doctorController,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    decoration: const InputDecoration(labelText: "Notes"),
                    maxLines: 3,
                    controller: notesController,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                widget.close();
                              },
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: isSubmitting ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditing
                                    ? "Update Appointment"
                                    : "Save Appointment",
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
