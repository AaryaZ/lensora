import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kScrollbarThickness = 12.0;

class MyScrollbar extends StatefulWidget {
  final ScrollableWidgetBuilder builder;
  final ScrollController? scrollController;

  const MyScrollbar({
    Key? key,
    this.scrollController,
    required this.builder,
  }) : super(key: key);

  @override
  _MyScrollbarState createState() => _MyScrollbarState();
}

class _MyScrollbarState extends State<MyScrollbar> {
  late ScrollController _scrollController; // Made this non-nullable
  ScrollbarPainter? _scrollbarPainter;
  Orientation? _orientation;

  @override
  void initState() {
    super.initState();
    // Initialize the scrollController with the provided one, or create a new one if it's null
    _scrollController = widget.scrollController ?? ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _updateScrollPainter(_scrollController.position);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Build the scrollbar painter when dependencies change
    _scrollbarPainter = _buildMaterialScrollbarPainter();
  }

  @override
  void dispose() {
    // Dispose the scrollController and the scrollbar painter when done
    _scrollController.dispose();
    _scrollbarPainter?.dispose();
    super.dispose();
  }

  ScrollbarPainter _buildMaterialScrollbarPainter() {
    return ScrollbarPainter(
      color: Colors.orange,
      textDirection: Directionality.of(context),
      thickness: _kScrollbarThickness,
      radius: Radius.circular(20),
      fadeoutOpacityAnimation: AlwaysStoppedAnimation(1.0),
      padding: EdgeInsets.only(top: 15, right: 15, bottom: 5, left: 5),
    );
  }

  bool _updateScrollPainter(ScrollMetrics position) {
    // Safely update the scrollbar painter with the current position
    _scrollbarPainter?.update(position, position.axisDirection);
    return false;
  }

  @override
  void didUpdateWidget(MyScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ensure that the scrollbar painter is updated when the widget is updated
    if (_scrollController.hasClients) {
      _updateScrollPainter(_scrollController.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Update _orientation when it changes
        if (_orientation != orientation) {
          _orientation = orientation;
          if (_scrollController.hasClients) {
            _updateScrollPainter(_scrollController.position);
          }
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Update scrollbar painter when the scroll position changes
            _updateScrollPainter(notification.metrics);
            return false;
          },
          child: CustomPaint(
            painter: _scrollbarPainter,
            child: widget.builder(context, _scrollController),
          ),
        );
      },
    );
  }
}
