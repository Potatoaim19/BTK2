import 'package:flutter/material.dart';
import '../../core/court_service.dart';
import '../../core/storage/token_storage.dart';
import '../../models/court.dart';
import '../auth/login_page.dart';
import '../booking/booking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<void> _logout() async {
    await TokenStorage.clear();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
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
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
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
            return const Center(child: Text('No courts available'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: courts.length,
              itemBuilder: (context, index) {
                final court = courts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(court.name),
                    subtitle: Text(
                      '${court.pricePerHour.toStringAsFixed(0)} VND / hour',
                    ),
                    trailing: court.isActive
                        ? const Icon(Icons.check_circle,
                            color: Colors.green)
                        : const Icon(Icons.cancel, color: Colors.red),
                    onTap: court.isActive
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingPage(
                                  courtId: court.id,
                                ),
                              ),
                            );
                          }
                        : null,
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

