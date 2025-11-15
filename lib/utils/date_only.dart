import 'package:intl/intl.dart';

DateTime parseDateOnly(dynamic value, {DateTime? fallback}) {
  if (value is DateTime) {
    return DateTime(value.year, value.month, value.day);
  }

  if (value is String) {
    final raw = value.trim();
    if (raw.isEmpty) return fallback ?? DateTime.now();

    final normalized = _normalize(raw);
    final parsed = DateTime.tryParse(normalized);
    if (parsed != null) {
      return DateTime(parsed.year, parsed.month, parsed.day);
    }

    for (final format in _fallbackFormats) {
      try {
        final result = DateFormat(format).parseStrict(raw);
        return DateTime(result.year, result.month, result.day);
      } catch (_) {
        continue;
      }
    }
  }

  return fallback ?? DateTime.now();
}

String _normalize(String raw) {
  if (raw.contains(' ') && !raw.contains('T')) {
    return raw.replaceFirst(' ', 'T');
  }
  return raw;
}

const List<String> _fallbackFormats = [
  'yyyy-MM-dd',
  'dd/MM/yyyy',
  'dd-MM-yyyy',
];
