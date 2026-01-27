import 'package:flutter/material.dart';
import '../../core/wallet_service.dart';
import '../../models/wallet.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Future<Wallet> _walletFuture;

  @override
  void initState() {
    super.initState();
    _walletFuture = WalletService.getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: FutureBuilder<Wallet>(
        future: _walletFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final wallet = snapshot.data!;

          return Column(
            children: [
              ListTile(
                title: const Text('Balance'),
                subtitle: Text(wallet.balance.toStringAsFixed(2)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: wallet.transactions.length,
                  itemBuilder: (context, i) {
                    final t = wallet.transactions[i];
                    return ListTile(
                      title: Text(t.description),
                      subtitle: Text(t.createdAt.toIso8601String()),
                      trailing: Text(t.amount.toString()),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
