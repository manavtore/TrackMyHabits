import 'package:flutter/material.dart';
import 'package:habit_tracker/core/utils/constants.dart';
import 'package:habit_tracker/features/routes/routes.dart';
import 'package:habit_tracker/features/web3/metamaskAuth.dart';
import 'package:provider/provider.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';


class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var loginNotifier = Notifier();

  @override
  void initState() {
    super.initState();
    loginNotifier.initializeState();
  }

  Widget build(BuildContext context) {
    var con = Constant();
    return ChangeNotifierProvider(
      create: (context) => loginNotifier,
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Healtify'),
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: 250,
                      width: 250,
                      image: AssetImage(
                        con.metamask,
                        
                        )),
                    W3MConnectWalletButton(service: loginNotifier.w3mService),
                    W3MNetworkSelectButton(service: loginNotifier.w3mService),
                    W3MAccountButton(service: loginNotifier.w3mService),
                    ElevatedButton(
                      onPressed: () {
                        if(loginNotifier.accountNo != ""){
                          Navigator.pushNamed(context, AppRoutes.homeRoute);
                        }
                        else{
                          Navigator.pushNamed(context, AppRoutes.loginMeta);
                        }
                        Navigator.pushNamed(context, AppRoutes.signupRoute);
                      },
                      child: const Text('Sign Up'),
                    ),
                    ElevatedButton(
                      onPressed:  (){
                        Navigator.pushNamed(context, AppRoutes.loginRoute);
                      },
                       child: const Text("Already have an account? Login"),)
                  ]
                  ),
            ),
          )),
    );
  }
}
