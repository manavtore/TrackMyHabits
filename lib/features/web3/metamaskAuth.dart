import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:habit_tracker/core/utils/constants.dart';

class Notifier extends ChangeNotifier {
  String _accountNo = "";
  String _balance = "";
  String _accountDetail = "";

  String get accountNo => _accountNo;
  String get balance => _balance;

  late W3MService w3mService;

  Future<void> initializeState() async {
    W3MChainPresets.chains.putIfAbsent('11155111', () => _sepoliaChain);
    w3mService = W3MService(
      projectId: 'ad97cf0cb32ec02d49278d00655f1ef5',
      metadata: const PairingMetadata(
        name: 'Healtify',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'Healify://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await w3mService.init();
  }

  void updateAccountNo() {
    _accountDetail = w3mService.loadAccountData().toString();
    _accountNo = _accountDetail;
    print(_accountNo);

    notifyListeners();
  }

  void updateBalance(String balance) {
    _balance = balance;
    notifyListeners();
  }

  void init() {}

    Future<void> logout() async {
    try {
      _accountNo = "";
      _balance = "";
      _accountDetail = "";

      notifyListeners();

      await w3mService.disconnect();
    } catch (e) {
      print("Logout failed: $e");
    }
  }

}

const chainId = "11155111";

final _sepoliaChain = W3MChainInfo(
  chainName: 'Sepolia',
  namespace: 'eip155:$chainId',
  chainId: chainId,
  tokenName: 'ETH',
  rpcUrl: 'https://rpc.sepolia.org/',
  blockExplorer: W3MBlockExplorer(
    name: 'Sepolia Explorer',
    url: 'https://sepolia.etherscan.io/',
  ),
);
