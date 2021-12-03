import 'package:flutter/material.dart';

class CollapsibleBottomNavigationBar extends StatefulWidget {
  final ScrollController controller;
  final BottomNavigationBar? bottomNavigationBar;
  const CollapsibleBottomNavigationBar(
      {Key? key, required this.controller, required this.bottomNavigationBar})
      : super(key: key);

  @override
  _CollapsibleBottomNavigationBarState createState() =>
      _CollapsibleBottomNavigationBarState();
}

class _CollapsibleBottomNavigationBarState
    extends State<CollapsibleBottomNavigationBar> {
  bool _bottomCollapse = false;
  @override
  void initState() {
    double _position = widget.controller.position.pixels;
    widget.controller.addListener(() {
      if (widget.controller.position.pixels > _position) {
        if (!_bottomCollapse)
          setState(() {
            if (widget.controller.position.pixels >
                widget.controller.position.minScrollExtent)
              _bottomCollapse = true;
            else
              _bottomCollapse = false;
          });
      } else if (widget.controller.position.pixels <= _position) {
        if (_bottomCollapse)
          setState(() {
            if (widget.controller.position.pixels <
                widget.controller.position.maxScrollExtent)
              _bottomCollapse = false;
          });
      }
      _position = widget.controller.position.pixels;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeInOut,
      height: !_bottomCollapse ? kBottomNavigationBarHeight : 0,
      child: Wrap(
        children: [widget.bottomNavigationBar!],
      ),
    );
  }
}
