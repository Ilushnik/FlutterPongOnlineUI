import 'package:flutter/material.dart';

class WaitingForOtherPlayer extends StatelessWidget {
  const WaitingForOtherPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text('Waiting for other player'),
    );
  }
}
