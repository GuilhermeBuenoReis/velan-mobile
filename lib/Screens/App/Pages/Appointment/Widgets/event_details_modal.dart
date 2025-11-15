import 'package:flutter/material.dart';

class EventDetailsModal extends StatelessWidget {
  final Map<String, dynamic>? event;
  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;

  const EventDetailsModal({
    super.key,
    required this.event,
    required this.isOpen,
    required this.onClose,
    this.onEdit,
    this.onDelete,
  });

  Color _bgColor(String color) {
    switch (color) {
      case 'purple':
        return const Color(0xFFEDE9FE);
      case 'orange':
        return const Color(0xFFFFEDD5);
      case 'red':
        return const Color(0xFFFECACA);
      default:
        return const Color(0xFFDBEAFE);
    }
  }

  Color _textColor(String color) {
    switch (color) {
      case 'purple':
        return const Color(0xFF4C1D95);
      case 'orange':
        return const Color(0xFF9A3412);
      case 'red':
        return const Color(0xFF7F1D1D);
      default:
        return const Color(0xFF1E3A8A);
    }
  }

  String _calendarLabel(String color) {
    switch (color) {
      case 'purple':
        return 'Personal';
      case 'orange':
        return 'Events';
      case 'red':
        return 'Important';
      default:
        return 'Work';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isOpen || event == null) return const SizedBox.shrink();

    final color = event!["color"] ?? "blue";

    final media = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: media.height * .85,
        ),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: _bgColor(color),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event!["title"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _textColor(color),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Detalhes completos do evento selecionado.",
                        style: TextStyle(
                          fontSize: 13,
                          color: _textColor(color).withValues(alpha: .8),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event!["time"],
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Duration: ${event!["durationHours"]} ${event!["durationHours"] == 1 ? "hour" : "hours"}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (event!["location"] != null &&
                          event!["location"] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  event!["location"],
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (event!["doctor"] != null && event!["doctor"] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Provider",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    event!["doctor"],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (event!["notes"] != null && event!["notes"] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.note_alt,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Notes",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      event!["notes"],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Calendar",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _calendarLabel(color),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: onClose,
                        child: const Text("Fechar"),
                      ),
                      const Spacer(),
                      if (onDelete != null)
                        TextButton.icon(
                          onPressed: () => _confirmDelete(context),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text("Excluir"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                        ),
                      if (onEdit != null) ...[
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text("Editar"),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    if (onDelete == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir consulta'),
          content: const Text(
            'Tem certeza de que deseja excluir esta consulta? Esta ação não poderá ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await onDelete!.call();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta excluída com sucesso.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir a consulta.')),
      );
    }
  }
}
