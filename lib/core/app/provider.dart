
import 'package:habit_tracker/features/auth/authcontroller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
class AppProvider {
    
    static  List<SingleChildWidget> provider =[
      ChangeNotifierProvider(create: (_)=>AuthenticationNotifier()),
      
    ];
} 