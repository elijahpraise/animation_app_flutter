import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  const Heart({super.key});

  @override
  State<Heart> createState() => _HeartState();
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _colorAnimation;
  late Animation _sizeAnimation;
  late Animation<double> _curve;
  bool _isFav = false;
  double weight = 50;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);
    _colorAnimation =
        ColorTween(begin: Colors.grey[400], end: Colors.red).animate(_curve);
    _sizeAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 30, end: 50), weight: weight),
      TweenSequenceItem(
          tween: Tween<double>(begin: 50, end: 30), weight: weight),
    ]).animate(_curve);
    _colorAnimation.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          _isFav = true;
        } else {
          _isFav = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, Widget? child) {
          return IconButton(
            icon: Icon(
              Icons.favorite,
              color: _colorAnimation.value,
              size: _sizeAnimation.value,
            ),
            onPressed: () {
              _isFav ? _controller.reverse() : _controller.forward();
            },
          );
        });
  }
}
