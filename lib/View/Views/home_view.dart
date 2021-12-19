import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/Preferences/app_routing.dart';
import 'package:news_app/View/Views/settings_view.dart';
import 'package:news_app/View/Views/top_headline_view.dart';
import 'package:news_app/View/Widgets/snack_bars.dart';
import 'package:news_app/ViewModel/Providers/connection_provider.dart';
import 'package:news_app/ViewModel/ViewModels/home_view_model.dart';
import 'package:provider/provider.dart';

import 'account_view.dart';

class HomeScreen extends StatefulWidget {
  final String? title;
  final Widget currentPage;
  const HomeScreen({Key? key, this.title, required this.currentPage})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeViewModel homeViewModel = HomeViewModel();
  //List<NewsModel>? news = [];
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool isLoading = false;
  bool loadMore = false;
  bool hadError = false;
  ConnectionProvider? _connectionProvider;
  // final List<Map<String, dynamic>> _tabs = [
  //   {
  //     'label': 'Home',
  //     'icon': Icons.home_outlined,
  //     'active': Icons.home,
  //   },
  //   {
  //     'label': 'Business',
  //     'icon': Icons.business_center_outlined,
  //     'active': Icons.business_center,
  //   },
  //   {
  //     'label': 'Sports',
  //     'icon': Icons.sports_basketball_outlined,
  //     'active': Icons.sports_basketball,
  //   },
  //   {
  //     'label': 'Politics',
  //     'icon': Icons.policy_outlined,
  //     'active': Icons.policy,
  //   },
  // ];

  List<int> _tabStack = [];

  int _currentTab = 0;

  bool bottomCollapse = false;

  //final String _category = 'business';
  //ScrollController? newsListController = ScrollController();
  AnimationController? slideTransitionController;

  // ignore: cancel_subscriptions
  late final StreamSubscription<ConnectivityResult>? connectivitySubscribtion;
  ConnectivityResult? connectivityCurrentState;

  List<Widget>? _pages = const [
    TopHeadLinePage(),
    TopHeadLinePage(),
    TopHeadLinePage(),
    TopHeadLinePage()
  ];

  @override
  void initState() {
    //newsListController!.addListener(_listener);
    // slideTransitionController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(
    //     milliseconds: 300,
    //   ),
    // );
    _checkConnectivity();
    connectivitySubscribtion =
        Connectivity().onConnectivityChanged.listen((connectivity) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _connectionProvider!.checkConectivity();
      if (connectivity != ConnectivityResult.none) {
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

          // if (news!.isNotEmpty)
          //   loadMoreNews();
          // else
          //   loadNews();
        }
      } else {
        // if (loadMore || isLoading)
        //   setState(() {
        //     loadMore = false;
        //     isLoading = false;
        //   });
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
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _connectionProvider!.checkConectivity());
    //loadNews();
    super.initState();
  }

  void _checkConnectivity() async {
    connectivityCurrentState = await Connectivity().checkConnectivity();
  }

  @override
  void dispose() {
    //newsListController!.removeListener(_listener);
    //newsListController!.dispose();
    //slideTransitionController!.dispose();
    connectivitySubscribtion!.cancel();
    super.dispose();
  }

  // void _listener() {
  //   if (newsListController!.position.pixels >
  //       newsListController!.position.minScrollExtent / 2) {
  //     if (homeViewModel.hasMore && !isLoading && !loading) {
  //       if (!loadMore) loadMoreNews();
  //     }
  //   }
  // }

  // void loadNews() async {
  //   if (!isLoading) setState(() => isLoading = true);
  //   final int _categoriesIndex = Random().nextInt(_categories.length);
  //   this.news = await homeViewModel.getTopHeadLineNews(
  //       TopHeadLineNewsApi(),
  //       news!.isNotEmpty ? news!.indexOf(news!.last) + 1 : 0,
  //       _country,
  //       _categories[_categoriesIndex]);
  //   if (isLoading) setState(() => isLoading = false);
  // }

  // void loadMoreNews() async {
  //   if (!loadMore) setState(() => loadMore = true);
  //   final int _categoriesIndex = Random().nextInt(_categories.length);
  //   List<NewsModel>? loaded = await homeViewModel.getTopHeadLineNews(
  //       TopHeadLineNewsApi(),
  //       news!.isNotEmpty ? news!.indexOf(news!.last) + 1 : 0,
  //       _country,
  //       _categories[_categoriesIndex]);
  //   if (!loading) {
  //     loaded!.forEach((element) {
  //       this.news!.add(element);
  //     });
  //   }
  //   if (loadMore) setState(() => loadMore = false);
  //   // if (loaded.isEmpty) {
  //   //   if (!hadError) setState(() => hadError = true);
  //   // } else if (hadError) setState(() => hadError = false);
  // }

  @override
  Widget build(BuildContext context) {
    _connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        // if (newsListController!.position.pixels >
        //         newsListController!.position.minScrollExtent &&
        //     !_scaffoldKey.currentState!.isDrawerOpen)
        //   return await showRefresh();
        // else
        if (_tabStack.isNotEmpty) {
          setState(() {
            _currentTab = _tabStack[_tabStack.length - 1];
            _tabStack.removeAt(_tabStack.length - 1);
          });
          return false;
        } else
          return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        //extendBody: true,
        // extendBodyBehindAppBar: true,
        drawer: Drawer(
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _buildDrawer(),
          ),
        ),
        // body: RefreshIndicator(
        //   key: refreshKey,
        //   onRefresh: () async {
        //     loading = true;
        //     await Future.delayed(const Duration(milliseconds: 200), () async {
        //       final int _categoriesIndex =
        //           Random().nextInt(_categories.length);
        //       var _news = await homeViewModel.getTopHeadLineNews(
        //           TopHeadLineNewsApi(),
        //           news!.isNotEmpty ? news!.indexOf(news!.last) + 1 : 0,
        //           _country,
        //           _categories[_categoriesIndex]);
        //       news!.clear();
        //       this.news = _news;
        //       loading = false;
        //       setState(() {
        //         newsListController!
        //             .jumpTo(newsListController!.position.minScrollExtent);
        //       });
        //     });
        //   },
        //   color: Colors.red,
        //   backgroundColor: Theme.of(context).backgroundColor,
        //   edgeOffset: 160,
        //   child: CustomScrollView(
        //     //primary: false,
        //     physics: news!.isNotEmpty
        //         ? const BouncingScrollPhysics()
        //         : const NeverScrollableScrollPhysics(),
        //     controller: newsListController,
        //     slivers: [
        //       CustomSliverAppBar(
        //         onRefresh: () => showRefresh(),
        //       ),
        //       SliverToBoxAdapter(
        //         child: _buildBody(),
        //       )
        //     ],
        //   ),
        // ),
        //   NestedScrollView(
        // physics: NeverScrollableScrollPhysics(),
        // controller: newsListController,
        // headerSliverBuilder: (context, i) => [
        //   buildSliverAppBar(),
        // ],
        // body: buildBody(),
        // ),
        body: _pages![_currentTab],
        // bottomNavigationBar: CollapsibleBottomNavigationBar(
        //   controller: newsListController!,
        //   bottomNavigationBar: BottomNavigationBar(
        //     unselectedItemColor:
        //         Theme.of(context).textTheme.headline4!.color!.withOpacity(0.4),
        //     selectedItemColor: Colors.red,
        //     currentIndex: _currentTab,
        //     type: BottomNavigationBarType.fixed,
        //     onTap: (index) {
        //       if (_currentTab != index) {
        //         setState(() {
        //           if (_tabStack.isEmpty ||
        //               (_tabStack.isNotEmpty && _currentTab != _tabStack.last))
        //             _tabStack.add(_currentTab);
        //           _currentTab = index;
        //         });
        //       }
        //     },
        //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     items: _tabs
        //         .map((e) => BottomNavigationBarItem(
        //               icon: Icon(e['icon']),
        //               activeIcon: Icon(e['active']),
        //               label: e['label'],
        //             ))
        //         .toList(),
        //   ),
        // ),
      ),
    );
  }

  // Widget buildSliverAppBar() {
  //   // Animation<Offset> anim = Tween(begin: Offset(0, 1), end: Offset.zero)
  //   //     .animate(CurvedAnimation(
  //   //         parent: slideTransitionController!, curve: Curves.easeInOut));
  //   final Tween<Offset> transitionTween =
  //       Tween(begin: const Offset(0, 1), end: Offset.zero);
  //   return SliverAppBar(
  //     title: const Text('News'),
  //     centerTitle: true,
  //     floating: true,
  //     pinned: true,
  //     snap: true,
  //     //primary: false,
  //     bottom: PreferredSize(
  //       preferredSize: const Size.fromHeight(74),
  //       child: GestureDetector(
  //         onTap: () {
  //           //slideTransitionController!.forward();
  //           Navigator.of(context).push(
  //             PageRouteBuilder(
  //               pageBuilder: (context, _, a) {
  //                 return const SearchScreen(
  //                     //controller: slideTransitionController!,
  //                     );
  //               },
  //               transitionsBuilder: (context, animation, a, child) {
  //                 return SlideTransition(
  //                   child: child,
  //                   position: transitionTween.animate(CurvedAnimation(
  //                       parent: animation, curve: Curves.easeInOut)),
  //                 );
  //               },
  //               transitionDuration: slideTransitionController!.duration!,
  //               reverseTransitionDuration: slideTransitionController!.duration!,
  //             ),
  //             //MaterialPageRoute(builder: (context) => SearchScreen()),
  //           );
  //         },
  //         child: Container(
  //           color: Colors.transparent,
  //           padding: const EdgeInsets.all(8),
  //           child: Card(
  //             color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
  //             child: Container(
  //               color: Colors.transparent,
  //               width: double.infinity,
  //               height: 50,
  //               padding: const EdgeInsets.all(15),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.max,
  //                 children: [
  //                   Icon(
  //                     Icons.search,
  //                     color:
  //                         Theme.of(context).iconTheme.color!.withOpacity(0.3),
  //                   ),
  //                   const SizedBox(
  //                     width: 15,
  //                   ),
  //                   Text(
  //                     'Search',
  //                     style: TextStyle(
  //                       color: Theme.of(context)
  //                           .textTheme
  //                           .headline4!
  //                           .color!
  //                           .withOpacity(0.3),
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),
  //           ),
  //         ),
  //       ),
  //     ),
  //     actions: [
  //       Transform.scale(
  //         scale: 0.75,
  //         child: IconButton(
  //           onPressed: () => showRefresh(),
  //           icon: const Icon(
  //             Icons.refresh,
  //             size: 35,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 15,
  //       ),
  //       GestureDetector(
  //         onTap: () => navigateTo(const AccountScreen()),
  //         child: CircleAvatar(
  //           radius: 16,
  //           child: FaIcon(
  //             FontAwesomeIcons.userAlt,
  //             size: 18,
  //             color: Theme.of(context).primaryColor,
  //           ),
  //           // child: Icon(
  //           //   Icons.account_circle_outlined,
  //           //   color: Theme.of(context).primaryColor,
  //           // ),
  //           backgroundColor: Colors.white.withOpacity(0.4),
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 15,
  //       ),
  //       // Icon(Platform.isAndroid ? Icons.android : Icons.phone_iphone),
  //       // SizedBox(
  //       //   width: 10,
  //       // )
  //     ],
  //   );
  // }

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

  // Widget _buildBody() => GestureDetector(
  //       onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
  //       child: _buildBodyContent(),
  //     );

  // Widget buildAlternateBody() => news!.isEmpty && !isLoading
  //     ? GestureDetector(
  //         onTap: () {
  //           // FocusScope.of(context).unfocus();
  //           SystemChannels.textInput.invokeMethod('TextInput.hide');
  //         },
  //         child: Container(
  //           color: Colors.transparent,
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.height * 0.75,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.max,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Icon(
  //                 connectivityCurrentState == ConnectivityResult.none
  //                     ? Icons.wifi_off_rounded
  //                     : Icons.warning_amber_rounded,
  //                 size: 115,
  //                 color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
  //               ),
  //               Text(
  //                 connectivityCurrentState == ConnectivityResult.none
  //                     ? 'Check Your Internet Connection'
  //                     : 'Somthing Went Wrong',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   color: Theme.of(context)
  //                       .textTheme
  //                       .headline4!
  //                       .color!
  //                       .withOpacity(0.3),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //     : news!.isEmpty && isLoading
  //         ? GestureDetector(
  //             onTap: () {
  //               // FocusScope.of(context).unfocus();
  //               SystemChannels.textInput.invokeMethod('TextInput.hide');
  //             },
  //             child: Center(
  //               child: Container(
  //                 color: Colors.transparent,
  //                 width: MediaQuery.of(context).size.width,
  //                 height: MediaQuery.of(context).size.height * 0.75,
  //                 child: const CustomCircularIndicator(
  //                   color: Colors.red,
  //                 ),
  //               ),
  //             ),
  //           )
  //         : GestureDetector(
  //             onTap: () {
  //               // FocusScope.of(context).unfocus();
  //               SystemChannels.textInput.invokeMethod('TextInput.hide');
  //             },
  //             child: Column(
  //               children: [
  //                 ...news!
  //                     .map((e) => NewsCardWidget(
  //                           id: '${news!.indexOf(e)}',
  //                           model: e,
  //                         ))
  //                     .toList(),
  //                 loadMore && !hadError
  //                     ? const SizedBox(
  //                         height: 50,
  //                         child: const CustomCircularIndicator(
  //                           color: Colors.red,
  //                         ),
  //                       )
  //                     : hadError
  //                         ? Center(
  //                             child: Column(
  //                               children: [
  //                                 Icon(
  //                                   Icons.wifi_off_rounded,
  //                                   size: 50,
  //                                   color: Theme.of(context)
  //                                       .iconTheme
  //                                       .color!
  //                                       .withOpacity(0.3),
  //                                 ),
  //                                 Text(
  //                                   'Check Your Internet Connection',
  //                                   style: TextStyle(
  //                                     fontSize: 18,
  //                                     color: Theme.of(context)
  //                                         .textTheme
  //                                         .headline4!
  //                                         .color!
  //                                         .withOpacity(0.3),
  //                                   ),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 15,
  //                                 ),
  //                               ],
  //                             ),
  //                           )
  //                         : const SizedBox(),
  //               ],
  //             ),
  //           );

  // Widget _buildBodyContent() =>
  //     news!.isEmpty && connectivityCurrentState == ConnectivityResult.none
  //         ? Center(
  //             child: Container(
  //               color: Colors.transparent,
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.height * 0.75,
  //               child: _buildConnectionError(),
  //             ),
  //           )
  //         : news!.isEmpty && isLoading
  //             ? _buildLoading()
  //             : news!.isNotEmpty && !isLoading && !homeViewModel.hasError
  //                 ? _buildNewsList()
  //                 : Center(
  //                     child: Container(
  //                       color: Colors.transparent,
  //                       width: MediaQuery.of(context).size.width,
  //                       height: MediaQuery.of(context).size.height * 0.75,
  //                       child: _buildDataError(),
  //                     ),
  //                   );

  // Widget _buildNewsList() => Column(
  //       children: [
  //         ...news!
  //             .map((e) => NewsCardWidget(
  //                   id: '${news!.indexOf(e)}',
  //                   model: e,
  //                 ))
  //             .toList(),
  //         loadMore && !homeViewModel.hasError
  //             ? const SizedBox(
  //                 height: 50,
  //                 child: const CustomCircularIndicator(
  //                   color: Colors.red,
  //                 ),
  //               )
  //             : !homeViewModel.hasError &&
  //                     connectivityCurrentState == ConnectivityResult.none
  //                 ? Center(
  //                     child: Column(
  //                       children: [
  //                         Icon(
  //                           Icons.wifi_off_rounded,
  //                           size: 50,
  //                           color: Theme.of(context)
  //                               .iconTheme
  //                               .color!
  //                               .withOpacity(0.3),
  //                         ),
  //                         Text(
  //                           'Check Your Internet Connection',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             color: Theme.of(context)
  //                                 .textTheme
  //                                 .headline4!
  //                                 .color!
  //                                 .withOpacity(0.3),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           height: 15,
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 : homeViewModel.hasError
  //                     ? Center(
  //                         child: Column(
  //                           children: [
  //                             Icon(
  //                               Icons.warning_amber_rounded,
  //                               size: 50,
  //                               color: Theme.of(context)
  //                                   .iconTheme
  //                                   .color!
  //                                   .withOpacity(0.3),
  //                             ),
  //                             Text(
  //                               'Somthing Went Wrong',
  //                               style: TextStyle(
  //                                 fontSize: 18,
  //                                 color: Theme.of(context)
  //                                     .textTheme
  //                                     .headline4!
  //                                     .color!
  //                                     .withOpacity(0.3),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 15,
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : const SizedBox(),
  //       ],
  //     );

  //Navigation Pages
  // Widget _buildNewsList() {
  //   switch (_currentTab) {
  //     case 0:
  //       return _buildHome();
  //     default:
  //       return _buildBusiness();
  //   }
  // }

  //Top-Headline Page
  // Widget _buildHome() => ListView.builder(
  //       key: PageStorageKey('HomeList'),
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: news!.length + 1,
  //       itemBuilder: (context, index) => index < news!.length
  //           ? NewsCardWidget(
  //               id: '$index',
  //               model: news![index],
  //             )
  //           : loadMore && !homeViewModel.hasError
  //               ? const SizedBox(
  //                   height: 50,
  //                   child: const CustomCircularIndicator(
  //                     color: Colors.red,
  //                   ),
  //                 )
  //               : !homeViewModel.hasError &&
  //                       connectivityCurrentState == ConnectivityResult.none
  //                   ? _buildListEndError('Connection')
  //                   : homeViewModel.hasError
  //                       ? _buildListEndError('Data')
  //                       : const SizedBox(),
  //     );

  // //Business Page
  // Widget _buildBusiness() => CustomCircularIndicator(
  //       color: Colors.red,
  //     );

  // //Loading
  // Widget _buildLoading() => Center(
  //       child: Container(
  //         color: Colors.transparent,
  //         width: MediaQuery.of(context).size.width,
  //         height: MediaQuery.of(context).size.height * 0.75,
  //         child: const CustomCircularIndicator(
  //           color: Colors.red,
  //         ),
  //       ),
  //     );

  // //Connection Error
  // Widget _buildConnectionError() => Column(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Icon(
  //           Icons.wifi_off_rounded,
  //           size: 115,
  //           color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
  //         ),
  //         Text(
  //           'Check Your Internet Connection',
  //           style: TextStyle(
  //             fontSize: 20,
  //             color: Theme.of(context)
  //                 .textTheme
  //                 .headline4!
  //                 .color!
  //                 .withOpacity(0.3),
  //           ),
  //         ),
  //       ],
  //     );

  // //Data Fetch Error
  // Widget _buildDataError() => Column(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Icon(
  //           Icons.warning_amber_rounded,
  //           size: 115,
  //           color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
  //         ),
  //         Text(
  //           'Somthing Went Wrong',
  //           style: TextStyle(
  //             fontSize: 20,
  //             color: Theme.of(context)
  //                 .textTheme
  //                 .headline4!
  //                 .color!
  //                 .withOpacity(0.3),
  //           ),
  //         ),
  //       ],
  //     );

  // //List End Errors
  // Widget _buildListEndError(String errorType) => Center(
  //       child: Column(
  //         children: [
  //           Icon(
  //             errorType == 'Connection'
  //                 ? Icons.wifi_off_rounded
  //                 : Icons.warning_amber_rounded,
  //             size: 50,
  //             color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
  //           ),
  //           Text(
  //             errorType == 'Connection'
  //                 ? 'Check Your Internet Connection'
  //                 : 'Somthing Went Wrong',
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Theme.of(context)
  //                   .textTheme
  //                   .headline4!
  //                   .color!
  //                   .withOpacity(0.3),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 15,
  //           ),
  //         ],
  //       ),
  //     );

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
        onTap: () => AppRoute.popAndNavigateTo(
            context, widget.currentPage, const AccountScreen()),
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
        onTap: () => AppRoute.popAndNavigateTo(
            context, widget.currentPage, const AccountScreen()),
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
            AppRoute.popAndNavigateTo(
                context, widget.currentPage, const SettingsScreen());
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
      .push(MaterialPageRoute(builder: (context) => screen));

  // Future<bool> showRefresh() async {
  //   //homeViewModel.hasMore = true;
  //   if (!loading) {
  //     loading = true;
  //     setState(() {
  //       loadMore = false;
  //       hadError = false;
  //       bottomCollapse = false;
  //     });
  //     newsListController!.animateTo(
  //         newsListController!.position.minScrollExtent,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.easeInOut);
  //     refreshKey.currentState!.show();
  //   }
  //   return !loading;
  // }
}
