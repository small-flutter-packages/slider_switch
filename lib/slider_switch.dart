library slider_switch;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SliderSwitch extends StatefulWidget {
  final Axis orientation;
  final bool withSpring;

  final bool initialStatus;
  final ValueChanged<bool>? onChanged;

  // dimensions
  final double width;
  final double lenght;

  // status colors
  final Color statusOnColor;
  final Color statusOffColor;
  final double statusColorOpacity;

  // status icons
  final IconData statusOnIcon;
  final IconData statusOffIcon;

  SliderSwitch({
    Key? key,
    this.initialStatus = false,
    this.onChanged,
    this.orientation = Axis.vertical,
    this.withSpring = true,
    this.width = 50.0,
    this.lenght = 130.0,
    this.statusOnColor = Colors.green,
    this.statusOffColor = Colors.grey,
    this.statusOnIcon = Icons.volume_up,
    this.statusOffIcon = Icons.volume_off,
    this.statusColorOpacity = 0.5,
  }) : super(key: key);

  @override
  _SliderSwitchState createState() => _SliderSwitchState();
}

class _SliderSwitchState extends State<SliderSwitch>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animation;
  late AnimationController _controller;
  late bool _status;
  late double _startAnimationPosX;
  late double _startAnimationPosY;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _status = widget.initialStatus;

    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    if (widget.orientation == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(2.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.8))
          .animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: FittedBox(
        child: Container(
          width: widget.orientation == Axis.horizontal
              ? widget.lenght
              : widget.width,
          height: widget.orientation == Axis.horizontal
              ? widget.width
              : widget.lenght,
          child: Material(
            type: MaterialType.canvas,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(50.0),
            color: _status
                ? widget.statusOnColor.withOpacity(widget.statusColorOpacity)
                : widget.statusOffColor.withOpacity(widget.statusColorOpacity),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: widget.orientation == Axis.horizontal
                      ? widget.width / 4
                      : null,
                  bottom: widget.orientation == Axis.horizontal
                      ? null
                      : widget.width / 4,
                  child: Icon(
                    widget.statusOffIcon,
                    size: widget.width / 2,
                    color:
                        !_status ? Colors.black : Colors.white.withOpacity(0.7),
                  ),
                ),
                Positioned(
                  right: widget.orientation == Axis.horizontal
                      ? widget.width / 4
                      : null,
                  top: widget.orientation == Axis.horizontal
                      ? null
                      : widget.width / 4,
                  child: Icon(
                    widget.statusOnIcon,
                    size: widget.width / 2,
                    color:
                        _status ? Colors.black : Colors.white.withOpacity(0.7),
                  ),
                ),
                GestureDetector(
                  onHorizontalDragStart: _onPanStart,
                  onHorizontalDragUpdate: _onPanUpdate,
                  onHorizontalDragEnd: _onPanEnd,
                  child: SlideTransition(
                    position: _animation,
                    child: SizedBox(
                      width: widget.width - 10,
                      child: Material(
                        color: Colors.white.withOpacity(0.6),
                        shape: const CircleBorder(),
                        elevation: 5.0,
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  child: child, scale: animation);
                            },
                            // child: Icon(
                            //   Icons.stream,
                            //   size: 30.0,
                            //   color: Colors.black54,
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;
    _startAnimationPosY = ((local.dy * 0.75) / box.size.height) - 0.4;
    if (widget.orientation == Axis.horizontal) {
      return ((local.dx * 0.75) / box.size.width) - 0.4;
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    bool isHor = widget.orientation == Axis.horizontal;
    bool changed = false;
    if (_controller.value <= -0.20) {
      // setState(() => isHor ? true : false);
      setState(() => _status = isHor ? false : true);
      changed = true;
    } else if (_controller.value >= 0.20) {
      // setState(() => isHor ? false : true);
      setState(() => _status = isHor ? true : false);
      changed = true;
    }
    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
          new SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );
      if (widget.orientation == Axis.horizontal) {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
      } else {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosY, 0.0, 0.0));
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

    if (changed && widget.onChanged != null) {
      widget.onChanged!(_status);
    }
  }
}
