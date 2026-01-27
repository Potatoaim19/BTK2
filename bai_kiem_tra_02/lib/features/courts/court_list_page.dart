import 'package:flutter/material.dart';
import '../../core/court_service.dart';
import '../../models/court.dart';
import '../booking/booking_page.dart';

class CourtListPage extends StatefulWidget {
  const CourtListPage({super.key});

  @override
  State<CourtListPage> createState() => _CourtListPageState();
}

class _CourtListPageState extends State<CourtListPage> {
  late Future<List<Court>> _courtsFuture;

  @override
  void initState() {
    super.initState();
    _courtsFuture = CourtService.getCourts();
  }

  Future<void> _refresh() async {
    setState(() {
      _courtsFuture = CourtService.getCourts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          )
        ],
      ),
      body: FutureBuilder<List<Court>>(
        future: _courtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final courts = snapshot.data ?? [];

          if (courts.isEmpty) {
            return const Center(
              child: Text('No courts available'),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: courts.length,
              itemBuilder: (context, i) {
                final c = courts[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(c.name),
                    subtitle: Text(
                      '${c.pricePerHour.toStringAsFixed(0)} / hour',
                    ),
                    trailing: ElevatedButton(
                      child: const Text('Book'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BookingPage(courtId: c.id),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
