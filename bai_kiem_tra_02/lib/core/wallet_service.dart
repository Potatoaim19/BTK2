import 'dart:convert';
import 'api_client.dart';
import 'storage/token_storage.dart';
import '../models/wallet.dart';

class WalletService {
  static Future<Wallet> getWallet() async {
    final token = await TokenStorage.read();

    final res = await ApiClient.get(
      '/api/wallet',
      token: token,
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return Wallet.fromJson(data);
    } else {
      throw Exception('Failed to load wallet');
    }
  }
}
