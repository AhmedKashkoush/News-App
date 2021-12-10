import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRoute {
  static void navigateTo(
          BuildContext context, Widget currentPage, Widget screen) =>
      Navigator.of(context).push(CustomParallaxRightSlideTransition(
          currentPage: currentPage, page: screen));
  static void popAndNavigateTo(
      BuildContext context, Widget currentPage, Widget screen) {
    Navigator.pop(context);
    navigateTo(context, currentPage, screen);
  }
}

class CustomParallaxRightSlideTransition extends PageRouteBuilder {
  final Widget page;
  final Widget currentPage;
  CustomParallaxRightSlideTransition({
    required this.page,
    required this.currentPage,
  }) : super(
          pageBuilder: (context, _, a) {
            return page;
          },
          transitionsBuilder: (context, animation, a, child) {
            final Curve curve = Curves.easeOut;
            return Stack(
              children: [
                // SlideTransition(
                //   child: currentPage,
                //   position:
                //       Tween(begin: Offset.zero, end: const Offset(-0.15, 0))
                //           .animate(
                //               CurvedAnimation(parent: animation, curve: curve)),
                // ),
                SlideTransition(
                  child: page,
                  position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(
                          CurvedAnimation(parent: animation, curve: curve)),
                ),
              ],
            );
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ),
          reverseTransitionDuration: const Duration(
            milliseconds: 300,
          ),
        );
}

// class CustomSlideTransitionParent extends StatefulWidget {
//   final Widget child;
//   static Offset? start = Offset.zero;
//   static Offset? end = const Offset(-0.15, 0);
//   static late Animation<double> animation;
//   static Curve curve = Curves.easeInOut;
//   static AnimationController? anim;
//   const CustomSlideTransitionParent({Key? key, required this.child})
//       : super(key: key);

//   @override
//   _CustomSlideTransitionParentState createState() =>
//       _CustomSlideTransitionParentState();

//   static void startTransition(
//       {required Offset? start,
//       required Offset? end,
//       required Animation<double> animation,
//       required Curve curve}) {
//     CustomSlideTransitionParent.start = start;
//     CustomSlideTransitionParent.end = end;
//     CustomSlideTransitionParent.animation = animation;
//     CustomSlideTransitionParent.curve = curve;
//     if (animation.isCompleted) {
//       if (animation. == AnimationStatus.forward)
//         anim!.forward();
//       else
//         anim!.reverse();
//     }
//   }
// }

// class _CustomSlideTransitionParentState
//     extends State<CustomSlideTransitionParent>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     CustomSlideTransitionParent.anim = AnimationController(
//       vsync: this,
//       duration: const Duration(
//         milliseconds: 600,
//       ),
//       reverseDuration: const Duration(
//         milliseconds: 600,
//       ),
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       child: widget.child,
//       position: Tween(begin: Offset.zero, end: const Offset(-0.15, 0)).animate(
//           CurvedAnimation(
//               parent: CustomSlideTransitionParent.anim!,
//               curve: CustomSlideTransitionParent.curve)),
//     );
//   }
// }
