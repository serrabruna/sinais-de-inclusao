import 'package:flutter/material.dart';

class AlignmentPlatform extends StatelessWidget {
  final Alignment alignment;
  final Widget child;
  
  const AlignmentPlatform({
    super.key, 
    required this.alignment, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment, 
      child: SizedBox(
        width: 140, 
        child: child,
      ),
    );
  }
}