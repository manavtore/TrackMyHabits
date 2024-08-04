import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ClickableCard extends StatelessWidget {
  const ClickableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
        
          },
          child: GFCard(
            boxFit: BoxFit.cover,
            image: Image.asset('assets/your_image.png'),
            title: const GFListTile(
             
              title: Text('Card Title'),
              subTitle: Text('Card Sub Title'),
            ),
            content: const Text("Some quick example text to build on the card"),
            buttonBar: GFButtonBar(
              children: <Widget>[
                GFButton(
                  onPressed: () {},
                  text: 'Buy',
                ),
                GFButton(
                  onPressed: () {},
                  text: 'Cancel',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
