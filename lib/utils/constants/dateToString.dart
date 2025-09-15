import 'package:intl/intl.dart';

String dateToString(DateTime t) {
  return DateFormat('MMMM d, y').format(t);
}

String getDurationDifference(DateTime start, DateTime end) {
  final duration = end.difference(start);

  final days = duration.inDays;
  final hours = duration.inHours.remainder(24);
  final minutes = duration.inMinutes.remainder(60);

  List<String> parts = [];

  if (days > 0) parts.add('$days day${days == 1 ? '' : 's'}');
  if (hours > 0) parts.add('$hours hour${hours == 1 ? '' : 's'}');
  if (minutes > 0 || parts.isEmpty) parts.add('$minutes minute${minutes <= 1 ? '' : 's'}');

  return parts.join(', ');
}

String timeAgo(DateTime t) {

  final now = DateTime.now();
  final diff = now.difference(t);
  final dateFormat = DateFormat('d MMM yyyy \'at\' h:mm a');

  if (diff.inSeconds < 60) {
    return 'just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} min${diff.inMinutes == 1 ? '' : 's'} ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else {
    // Optional: show full date if > 7 days
    return dateFormat.format(t);
  }
}