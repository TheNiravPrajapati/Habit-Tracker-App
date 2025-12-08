import 'package:flutter/material.dart';

class AchievementBadge extends StatefulWidget {
  final String label;
  final bool achieved;

  const AchievementBadge({
    super.key,
    required this.label,
    required this.achieved,
  });

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _rotate;
  late Animation<Color?> _glow;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Pop Animation
    _scale = Tween<double>(begin: 0.85, end: 1.15)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_controller);

    // Rotate unlock icon
    _rotate = Tween<double>(begin: -0.4, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Glow effect
    _glow = ColorTween(
      begin: Colors.grey.shade300,
      end: Colors.amberAccent,
    ).animate(_controller);

    // Trigger animation if achieved
    if (widget.achieved) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AchievementBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.achieved && !oldWidget.achieved) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return ScaleTransition(
              scale: _scale,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: widget.achieved
                      ? [
                    BoxShadow(
                      color: _glow.value!,
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                      : [],
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor:
                  widget.achieved ? Colors.teal : Colors.grey.shade300,
                  child: Transform.rotate(
                    angle: _rotate.value,
                    child: Icon(
                      widget.achieved ? Icons.check : Icons.lock,
                      color: widget.achieved ? Colors.white : Colors.grey,
                      size: 32,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 6),
        Text(widget.label),
      ],
    );
  }
}
