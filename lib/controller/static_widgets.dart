import 'package:flutter/material.dart';

class StaticWidgets {
  ScrollController scrollController = ScrollController();

  showBottom(
      BuildContext context, Widget widget, double min, double max) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
            expand: false,
            snap: true,
            minChildSize: min,
            maxChildSize: max,
            snapSizes: [min, max],
            initialChildSize: min,
            builder: (context, sc) {
              scrollController = sc;
              return Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 5,
                    child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.amber.shade300)),
                  ),
                  widget,
                ],
              );
            }),
      ),
    );
  }
}
