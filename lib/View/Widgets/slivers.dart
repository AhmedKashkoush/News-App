import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/Preferences/app_routing.dart';
import 'package:news_app/View/Views/account_view.dart';
import 'package:news_app/View/Views/search_view.dart';

// ignore: must_be_immutable
class CustomSliverAppBar extends StatefulWidget {
  final VoidCallback onRefresh;
  final Widget currentPage;

  String search;
  CustomSliverAppBar({
    Key? key,
    required this.onRefresh,
    required this.currentPage,
    required this.search,
  }) : super(key: key);

  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Tween<Offset> transitionTween =
        Tween(begin: const Offset(0, 1), end: Offset.zero);
    final Duration duration = const Duration(
      milliseconds: 300,
    );
    return SliverAppBar(
      title: const Text('News'),
      centerTitle: true,
      floating: true,
      pinned: true,
      snap: true,
      //primary: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: GestureDetector(
          onTap: () {
            //slideTransitionController!.forward();
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, _, a) {
                  return const SearchScreen(
                      //controller: slideTransitionController!,
                      );
                },
                transitionsBuilder: (context, animation, a, child) {
                  return SlideTransition(
                    child: child,
                    position: transitionTween.animate(CurvedAnimation(
                        parent: animation, curve: Curves.easeInOut)),
                  );
                },
                transitionDuration: duration,
                reverseTransitionDuration: duration,
              ),
              //MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            child: Card(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.search,
                      color:
                          Theme.of(context).iconTheme.color!.withOpacity(0.3),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Search', //widget.search,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .headline4!
                            .color!
                            .withOpacity(0.3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ),
      actions: [
        Transform.scale(
          scale: 0.75,
          child: IconButton(
            onPressed: widget.onRefresh,
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: () => AppRoute.navigateTo(
              context, widget.currentPage, const AccountScreen()),
          child: CircleAvatar(
            radius: 16,
            child: FaIcon(
              FontAwesomeIcons.userAlt,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            // child: Icon(
            //   Icons.account_circle_outlined,
            //   color: Theme.of(context).primaryColor,
            // ),
            backgroundColor: Colors.white.withOpacity(0.4),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        // Icon(Platform.isAndroid ? Icons.android : Icons.phone_iphone),
        // SizedBox(
        //   width: 10,
        // )
      ],
    );
  }
}
