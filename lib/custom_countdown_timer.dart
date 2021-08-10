import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Create a Circular Countdown Timer
class CircularCountDownDate extends StatefulWidget {
  /// Filling Color for Countdown Timer
  final Color fillColor;

  /// Default Color for Countdown Timer
  final Color color;

  /// Function which will execute when the Countdown Ends
  final Function onComplete;

  /// Countdown Duration in Seconds

  /// Width of the Countdown Widget
  final double width;

  /// Height of the Countdown Widget
  final double height;

  /// Border Thickness of the Countdown Circle
  final double strokeWidth;

  /// Text Style for Countdown Text
  final TextStyle textStyle;

  /// true for reverse countdown (max to 0), false for forward countdown (0 to max)
  final bool isReverse;

  final DateTime startDate;
  final DateTime endDate;
  final Widget belowWidget;

  CircularCountDownDate(
      {@required this.width,
      @required this.height,
      @required this.fillColor,
      @required this.color,
      @required this.startDate,
      @required this.endDate,
      this.isReverse,
      this.onComplete,
      this.strokeWidth,
      this.textStyle,
      this.belowWidget})
      : assert(width != null),
        assert(height != null),
        assert(fillColor != null),
        assert(color != null),
        assert(startDate != null),
        assert(endDate != null);

  @override
  _CircularCountDownDateState createState() => _CircularCountDownDateState();
}

class _CircularCountDownDateState extends State<CircularCountDownDate>
    with TickerProviderStateMixin {
  AnimationController controller;

  bool flag = true;
  String time;

  String get timerString {
    _setDateFormat(widget.endDate);
    return time;
  }

  void _setDateFormat(DateTime endDate) {
    int ss = endDate.day - DateTime.now().day;
    time = ss.toString();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: CustomTimerPainter(
                                      animation: controller,
                                      fillColor: widget.fillColor,
                                      color: widget.color,
                                      strokeWidth: widget.strokeWidth,
                                      endDate: widget.endDate,
                                      startDate: widget.startDate,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        timerString,
                                        style: widget.textStyle ??
                                            TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black),
                                      ),
                                      widget.belowWidget ?? Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.fillColor,
    this.color,
    this.strokeWidth,
    this.startDate,
    this.endDate,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final DateTime startDate;
  final DateTime endDate;
  final Color fillColor, color;
  final double strokeWidth;

  double _currentProgress() {
    return DateTime.now().difference(startDate).inDays /
        endDate.difference(startDate).inDays;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth ?? 5.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - _currentProgress()) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        fillColor != old.fillColor;
  }
}
