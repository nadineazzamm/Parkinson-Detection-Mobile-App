import 'package:flutter/material.dart';
class mylist extends StatelessWidget {
  const mylist({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Text('data'),
        Text('data'),
        Text('data'),
        Text('data'),
        Text('data'),
        Text('data'),
        ElevatedButton(onPressed: (){}, child: Text('Click'))
      ],
    );
  }
}
