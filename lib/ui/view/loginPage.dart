import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/authcontroller.dart';
import 'package:habit_tracker/features/routes/routes.dart';
import 'package:provider/provider.dart';


class loginScreen extends StatefulWidget {

  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    
  }
  

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:Center(
        child: Column(
            children: [
              Padding(padding: const EdgeInsets.all(8.0),
               child: Column(
                  children: [
                   Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailController,  
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                    decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
                ),
              ),
              ElevatedButton( onPressed: () async{
                    String email = emailController.text;
                    String password = passwordController.text;
                    bool islog = false;
                    if(password.isNotEmpty && email.isNotEmpty){
                      await authenticationNotifier.signIn(email,password);
                      islog = true;
                      String user = authenticationNotifier.user!.uid;
                      
                    }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the fields')));  
                    }
                    if(islog){
                       Navigator.of(context).pushNamed(AppRoutes.homeRoute);
                    }
                   
                }, child: const Text('Login')
              ),    
              
                  ],
               ),
              ),
              
            ],

        ),
      ),
    );
  }}