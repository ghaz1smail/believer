import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating(
      {super.key, this.size = 20, required this.rate, this.tap = false});
  final double size;
  final List rate;
  final bool tap;

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _rating = 0;
  double calculate = 0;

  @override
  void initState() {
    if (!widget.tap && widget.rate.isNotEmpty) {
      _rating = (widget.rate.map((m) => m['rating']).reduce((a, b) => a + b) /
              widget.rate.length)
          .round();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return InkWell(
              onTap: widget.tap
                  ? () {
                      setState(() {
                        _rating = index + 1;
                      });
                    }
                  : null,
              child: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: widget.size,
              ),
            );
          }),
        ),
        Text('(${widget.rate.length})')
      ],
    );
  }
}
