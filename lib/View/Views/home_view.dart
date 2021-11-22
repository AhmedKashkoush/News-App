import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/Model/Apis/top_headline_news_api.dart';
import 'package:news_app/Model/Models/news_model.dart';
import 'package:news_app/View/Views/settings_view.dart';
import 'package:news_app/View/Views/search_view.dart';
import 'package:news_app/View/Widgets/indicators.dart';
import 'package:news_app/View/Widgets/news_card_widget.dart';
import 'package:news_app/View/Widgets/snack_bars.dart';
import 'package:news_app/ViewModel/ViewModels/home_view_model.dart';

import 'account_view.dart';

class HomeScreen extends StatefulWidget {
  final String? title;
  const HomeScreen({Key? key, this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeViewModel homeViewModel = HomeViewModel();
  List<NewsModel>? news = [];
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool isLoading = false;
  bool loadMore = false;
  bool hadError = false;

  final String _country = 'eg';
  final List<String> _categories = ['business', 'politics', 'sports'];
  //final String _category = 'business';
  ScrollController? newsListController = ScrollController();
  AnimationController? slideTransitionController;

  // ignore: cancel_subscriptions
  late final StreamSubscription<ConnectivityResult>? connectivitySubscribtion;
  ConnectivityResult? connectivityCurrentState;

  @override
  void initState() {
    newsListController!.addListener(() {
      if (newsListController!.position.pixels >
          newsListController!.position.minScrollExtent / 2) {
        if (homeViewModel.hasMore) {
          if (!loadMore) loadMoreNews();
        }
      }
    });
    slideTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _checkConnectivity();
    connectivitySubscribtion =
        Connectivity().onConnectivityChanged.listen((connectivity) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (connectivity != ConnectivityResult.none) {
        if (news!.isNotEmpty)
          loadMoreNews();
        else
          loadNews();

        if (connectivityCurrentState != connectivity) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              text: 'Back Online',
              backgroundColor: Colors.green,
              seconds: 2,
            ),
            // const SnackBar(
            //   content: const Text(
            //     'Back Online',
            //     style: const TextStyle(color: Colors.white),
            //   ),
            //   backgroundColor: Colors.green,
            //   duration: const Duration(seconds: 2),
            // ),
          );
        }
      } else {
        if (loadMore || isLoading)
          setState(() {
            loadMore = false;
            isLoading = false;
          });
        if (connectivityCurrentState != connectivity) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              text: 'You Are Offline',
              backgroundColor: Colors.grey[850],
              seconds: 2,
            ),
            // SnackBar(
            //   content: const Text(
            //     'You Are Offline',
            //     style: const TextStyle(color: Colors.white,fontWeight:FontWeight.bold),
            //   ),
            //   backgroundColor: Colors.grey[850],
            //   duration: const Duration(seconds: 2),
            // ),
          );
        }
      }
      connectivityCurrentState = connectivity;
    });

    print('init');
    loadNews();
    super.initState();
  }

  void _checkConnectivity() async {
    connectivityCurrentState = await Connectivity().checkConnectivity();
  }

  @override
  void dispose() {
    newsListController!.dispose();
    slideTransitionController!.dispose();
    connectivitySubscribtion!.cancel();
    super.dispose();
  }

  void loadNews() async {
    if (!isLoading) setState(() => isLoading = true);
    final int _categoriesIndex = Random().nextInt(_categories.length);
    this.news = await homeViewModel.getTopHeadLineNews(
        TopHeadLineNewsApi(),
        news!.isNotEmpty ? news!.indexOf(news!.last) + 1 : 0,
        _country,
        _categories[_categoriesIndex]);
    if (isLoading) setState(() => isLoading = false);
  }

  void loadMoreNews() async {
    if (!loadMore) setState(() => loadMore = true);
    final int _categoriesIndex = Random().nextInt(_categories.length);
    List<NewsModel>? loaded = await homeViewModel.getTopHeadLineNews(
        TopHeadLineNewsApi(),
        news!.isNotEmpty ? news!.indexOf(news!.last) + 1 : 0,
        _country,
        _categories[_categoriesIndex]);
    loaded!.forEach((element) {
      this.news!.add(element);
    });
    if (loadMore) setState(() => loadMore = false);
    if (loaded.isEmpty) {
      if (!hadError) setState(() => hadError = true);
    } else if (hadError) setState(() => hadError = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return newsListController!.position.pixels >
                    newsListController!.position.minScrollExtent &&
                !_scaffoldKey.currentState!.isDrawerOpen
            ? await showRefresh()
            : true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        // extendBodyBehindAppBar: true,
        drawer: Drawer(
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _buildDrawer(),
          ),
        ),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            loading = true;
            await Future.delayed(const Duration(milliseconds: 200), () async {
              news!.clear();
              final int _categoriesIndex = Random().nextInt(_categories.length);
              this.news = await homeViewModel.getTopHeadLineNews(
                  TopHeadLineNewsApi(),
                  news!.isNotEmpty ? news!.indexOf(news!.last) + 1 : 0,
                  _country,
                  _categories[_categoriesIndex]);
              loading = false;
              setState(() {
                //loadNews();
              });
            });
          },
          strokeWidth: 3,
          color: Colors.red,
          backgroundColor: Theme.of(context).backgroundColor,
          edgeOffset: 160,
          child: CustomScrollView(
            //primary: false,
            physics: news!.isNotEmpty
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            controller: newsListController,
            slivers: [
              buildSliverAppBar(),
              SliverToBoxAdapter(
                child: buildAlternateBody(),
              )
            ],
          ),
        ),
        //   NestedScrollView(
        // physics: NeverScrollableScrollPhysics(),
        // controller: newsListController,
        // headerSliverBuilder: (context, i) => [
        //   buildSliverAppBar(),
        // ],
        // body: buildBody(),
        // ),
      ),
    );
  }

  Widget buildSliverAppBar() {
    // Animation<Offset> anim = Tween(begin: Offset(0, 1), end: Offset.zero)
    //     .animate(CurvedAnimation(
    //         parent: slideTransitionController!, curve: Curves.easeInOut));
    final Tween<Offset> transitionTween =
        Tween(begin: const Offset(0, 1), end: Offset.zero);
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
                transitionDuration: slideTransitionController!.duration!,
                reverseTransitionDuration: slideTransitionController!.duration!,
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
                      'Search',
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
            onPressed: () => showRefresh(),
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
          onTap: () => navigateTo(const AccountScreen()),
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

  // Widget buildBody() => RefreshIndicator(
  //       key: refreshKey,
  //       onRefresh: () async {
  //         await Future.delayed(Duration(milliseconds: 200), () {
  //           loading = false;
  //           setState(() {
  //             news!.clear();
  //           });
  //         });
  //       },
  //       strokeWidth: 3,
  //       color: Colors.red,
  //       backgroundColor: Theme.of(context).backgroundColor,
  //       child: news!.isEmpty
  //           ? GestureDetector(
  //               onTap: () {
  //                 // FocusScope.of(context).unfocus();
  //                 SystemChannels.textInput.invokeMethod('TextInput.hide');
  //               },
  //               child: Container(
  //                 color: Colors.transparent,
  //                 width: MediaQuery.of(context).size.width,
  //                 height: MediaQuery.of(context).size.height * 0.75,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.max,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.error_outline_outlined,
  //                       size: 85,
  //                       color:
  //                           Theme.of(context).iconTheme.color!.withOpacity(0.5),
  //                     ),
  //                     Text(
  //                       'Somthing Went Wrong',
  //                       style: TextStyle(
  //                         fontSize: 25,
  //                         color: Theme.of(context)
  //                             .textTheme
  //                             .headline4!
  //                             .color!
  //                             .withOpacity(0.5),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           : GestureDetector(
  //               onTap: () {
  //                 // FocusScope.of(context).unfocus();
  //                 SystemChannels.textInput.invokeMethod('TextInput.hide');
  //               },
  //               child: SingleChildScrollView(
  //                 primary: true,
  //                 physics: BouncingScrollPhysics(),
  //                 child: Column(
  //                   children: [
  //                     ListView.builder(
  //                       physics: NeverScrollableScrollPhysics(),
  //                       shrinkWrap: true,
  //                       itemCount: news!.length + 1,
  //                       itemBuilder: (context, i) => i < news!.length
  //                           ? NewsCardWidget()
  //                           : loadMore
  //                               ? SizedBox(
  //                                   height: 50,
  //                                   child: Center(
  //                                     child: CircularProgressIndicator(
  //                                       color: Colors.red,
  //                                     ),
  //                                   ),
  //                                 )
  //                               : SizedBox(),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //     );

  Widget buildAlternateBody() => news!.isEmpty && !isLoading
      ? GestureDetector(
          onTap: () {
            // FocusScope.of(context).unfocus();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  connectivityCurrentState == ConnectivityResult.none
                      ? Icons.wifi_off_rounded
                      : Icons.warning_amber_rounded,
                  size: 115,
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
                ),
                Text(
                  connectivityCurrentState == ConnectivityResult.none
                      ? 'Check Your Internet Connection'
                      : 'Somthing Went Wrong',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context)
                        .textTheme
                        .headline4!
                        .color!
                        .withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        )
      : news!.isEmpty && isLoading
          ? GestureDetector(
              onTap: () {
                // FocusScope.of(context).unfocus();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: Center(
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: const CustomCircularIndicator(
                    color: Colors.red,
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                // FocusScope.of(context).unfocus();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: Column(
                children: [
                  ...news!
                      .map((e) => NewsCardWidget(
                            id: '${news!.indexOf(e)}',
                            model: e,
                          ))
                      .toList(),
                  loadMore && !hadError
                      ? const SizedBox(
                          height: 50,
                          child: const CustomCircularIndicator(
                            color: Colors.red,
                          ),
                        )
                      : hadError
                          ? Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.wifi_off_rounded,
                                    size: 50,
                                    color: Theme.of(context)
                                        .iconTheme
                                        .color!
                                        .withOpacity(0.3),
                                  ),
                                  Text(
                                    'Check Your Internet Connection',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .color!
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                ],
              ),
            );

  Widget _buildeListTile(
      {String? title,
      IconData? icon,
      VoidCallback? onTap,
      int? number,
      bool? hasNumber = false}) {
    assert((hasNumber == false && number == null) ||
        (hasNumber == true && number != null));
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title!,
        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18),
      ),
      trailing: hasNumber! && number! > 0
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Theme.of(context).primaryColor,
              ),
              child: Text(number < 100 ? '$number' : '+99',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white)),
            )
          : const SizedBox(),
    );
  }

  Widget _buildDrawer() {
    List<Widget> _drawerList = [
      GestureDetector(
        onTap: () => popDrawerAndNavigateTo(const AccountScreen()),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[700]!.withOpacity(0.4),
            radius: 20,
            child: FaIcon(
              FontAwesomeIcons.userAlt,
              size: 20,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          title: Text(
            'Name',
            style:
                Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18),
          ),
          subtitle: Text(
            'Email',
            style:
                Theme.of(context).textTheme.headline4!.copyWith(fontSize: 12),
          ),
        ),
      ),
      const Divider(
        thickness: 1,
      ),
      const SizedBox(
        height: 40,
      ),
      _buildeListTile(
        title: 'Account',
        icon: Icons.account_circle_outlined,
        onTap: () => popDrawerAndNavigateTo(const AccountScreen()),
      ),
      _buildeListTile(
        title: 'Notifications',
        icon: Icons.notifications_none_outlined,
        onTap: () {},
        hasNumber: true,
        number: 999,
      ),
      _buildeListTile(
          title: 'Manage Region',
          icon: Icons.location_on_outlined,
          onTap: () {}),
      _buildeListTile(
          title: 'Settings',
          icon: Icons.settings_outlined,
          onTap: () {
            popDrawerAndNavigateTo(const SettingsScreen());
          }),
      _buildeListTile(
          title: 'About', icon: Icons.info_outline_rounded, onTap: () {}),
      _buildeListTile(
          title: 'Log Out', icon: Icons.logout_outlined, onTap: () {}),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.28,
      ),
    ];
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ListView(
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   children: _drawerList,
              // ),
              ..._drawerList,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Made With ',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .headline4!
                          .color!
                          .withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const FlutterLogo(
                    size: 25,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Powered By ',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .headline4!
                          .color!
                          .withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Platform.isAndroid
                      ? Icon(
                          Icons.android,
                          color: Colors.green[400],
                        )
                      : const FaIcon(FontAwesomeIcons.apple)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void popDrawerAndNavigateTo(Widget screen) {
    Navigator.pop(context);
    navigateTo(screen);
  }

  void navigateTo(Widget screen) => Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => screen));

  Future<bool> showRefresh() async {
    //homeViewModel.hasMore = true;
    if (!loading) {
      loading = true;
      setState(() {
        loadMore = false;
        hadError = false;
      });
      newsListController!.animateTo(
          newsListController!.position.minScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
      refreshKey.currentState!.show();
    }
    return !loading;
  }
}
