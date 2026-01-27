import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/storage/token_storage.dart';

class BookingPage extends StatefulWidget {
  final int courtId;

  const BookingPage({super.key, required this.courtId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? start;
  DateTime? end;
  bool loading = false;

  Future<void> book() async {
    if (start == null || end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick start and end time')),
      );
      return;
    }

    if (end!.isBefore(start!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final token = await TokenStorage.read();

      final res = await ApiClient.post(
        '/api/bookings',
        {
          'courtId': widget.courtId,
          'startTime': start!.toIso8601String(),
          'endTime': end!.toIso8601String(),
        },
        token: token,
      );

      if (!mounted) return;

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successful')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${res.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _pickStart() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: DateTime.now(),
    );

    if (d == null) return;

    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (t == null) return;

    setState(() {
      start = DateTime(
        d.year,
        d.month,
        d.day,
        t.hour,
        t.minute,
      );
    });
  }

  Future<void> _pickEnd() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: start ?? DateTime.now(),
    );

    if (d == null) return;

    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (t == null) return;

    setState(() {
      end = DateTime(
        d.year,
        d.month,
        d.day,
        t.hour,
        t.minute,
      );
    });
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Not selected';
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Court')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickStart,
              child: Text(
                start == null
                    ? 'Pick start time'
                    : 'Start: ${_formatDateTime(start)}',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickEnd,
              child: Text(
                end == null
                    ? 'Pick end time'
                    : 'End: ${_formatDateTime(end)}',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : book,
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
