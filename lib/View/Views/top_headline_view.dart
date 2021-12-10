import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/Model/Apis/top_headline_news_api.dart';
import 'package:news_app/Model/Models/news_model.dart';
import 'package:news_app/View/Widgets/indicators.dart';
import 'package:news_app/View/Widgets/news_card_widget.dart';
import 'package:news_app/View/Widgets/slivers.dart';
import 'package:news_app/ViewModel/Providers/connection_provider.dart';
import 'package:news_app/ViewModel/ViewModels/home_view_model.dart';
import 'package:provider/provider.dart';

class TopHeadLinePage extends StatefulWidget {
  const TopHeadLinePage({
    Key? key,
  }) : super(key: key);

  @override
  _TopHeadLinePageState createState() => _TopHeadLinePageState();
}

class _TopHeadLinePageState extends State<TopHeadLinePage> {
  HomeViewModel _topHeadlineViewModel = HomeViewModel();
  List<NewsModel>? _news = [];
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  // bool _isLoading = false;
  // bool _loadMore = false;
  bool _isConnected = true;

  final String _country = 'eg';
  final List<String> _categories = ['business', 'politics', 'sports'];
  //final String _category = 'business';
  ScrollController? _newsListController = ScrollController();

  @override
  void initState() {
    _newsListController!.addListener(_listener);
    loadNews();
    super.initState();
  }

  @override
  void dispose() {
    _newsListController!.removeListener(_listener);
    _newsListController!.dispose();
    super.dispose();
  }

  void _listener() {
    loadMoreNews();
    // if (_topHeadlineViewModel.loadState != 'Loaded') {
    //   if (_news!.isNotEmpty) {
    //     if (_newsListController!.position.pixels >
    //         _newsListController!.position.minScrollExtent / 2) {
    //       loadMoreNews();
    //     }
    //   }
    // }
  }

  void loadNews() async {
    //if (!_isLoading) setState(() => _isLoading = true);
    //setState(() => _topHeadlineViewModel.loadState = 'Loading');

    final int _categoriesIndex = Random().nextInt(_categories.length);
    this._news = await _topHeadlineViewModel.getTopHeadLineNews(
        TopHeadLineNewsApi(),
        _news!.isNotEmpty ? _news!.indexOf(_news!.last) + 1 : 0,
        _country,
        _categories[_categoriesIndex]);
    setState(() {});
    //if (_isLoading) setState(() => _isLoading = false);
  }

  void loadMoreNews() async {
    //if (!_loadMore) _loadMore = true;
    if (_newsListController!.position.pixels >
        _newsListController!.position.maxScrollExtent -
            MediaQuery.of(context).size.height * 0.75) {
      if (_topHeadlineViewModel.hasMore &&
          _topHeadlineViewModel.loadState != 'Loading') {
        // if (_topHeadlineViewModel.loadState == 'Ok')
        setState(() {});

        final int _categoriesIndex = Random().nextInt(_categories.length);
        List<NewsModel>? _loaded =
            await _topHeadlineViewModel.getTopHeadLineNews(
                TopHeadLineNewsApi(),
                _news!.isNotEmpty ? _news!.indexOf(_news!.last) + 1 : 0,
                _country,
                _categories[_categoriesIndex]);
        //if (_topHeadlineViewModel.loadState != 'Loading') {
        this._news!.addAll(_loaded!);
        //}
        //if (_topHeadlineViewModel.loadState == 'Loading')
        setState(() {});
      }
    }
    //if (_loadMore) _loadMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(
      builder: (context, provider, _) {
        // if (_news!.isEmpty)
        //   loadNews();
        // else if (_topHeadlineViewModel.loadState != 'Loaded') loadMoreNews();
        if (!_isConnected &&
            provider.connectionState != ConnectivityResult.none) {
          _isConnected = true;
          //_topHeadlineViewModel.loadState = 'Loading';
          if (_news!.isEmpty)
            loadNews();
          else
            loadMoreNews();
          // if (_news!.isNotEmpty && _topHeadlineViewModel.hasMore)
          //   loadMoreNews();
        } else if (_isConnected &&
            provider.connectionState == ConnectivityResult.none)
          _isConnected = false;
        return RefreshIndicator(
          key: refreshKey,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 200), onRefresh);
          },
          color: Colors.red,
          backgroundColor: Theme.of(context).backgroundColor,
          edgeOffset: 160,
          child: CustomScrollView(
            //primary: false,
            key: PageStorageKey('TopHeadLine'),
            physics: _news!.isNotEmpty
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            controller: _newsListController,
            slivers: [
              CustomSliverAppBar(
                onRefresh: () => showRefresh(),
                currentPage: widget,
                search: _topHeadlineViewModel.loadState,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildBody(provider),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(ConnectionProvider provider) => GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: _buildBodyContent(provider),
      );
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

  Widget _buildBodyContent(ConnectionProvider provider) {
    if (_news!.isEmpty) {
      if (provider.connectionState != ConnectivityResult.none) {
        if (_topHeadlineViewModel.loadState == 'Loading')
          return _buildLoading();
        else if (_topHeadlineViewModel.loadState == 'Error')
          return Center(
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              child: _buildDataError(),
            ),
          );
      } else
        return Center(
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: _buildConnectionError(),
          ),
        );
    }
    return _buildHome(provider);
    //  if (_topHeadlineViewModel.loadState == 'Error' &&
    //             provider.connectionState == ConnectivityResult.none &&
    //             _news!.isEmpty)
    //         return Center(
    //             child: Container(
    //               color: Colors.transparent,
    //               width: MediaQuery.of(context).size.width,
    //               height: MediaQuery.of(context).size.height * 0.75,
    //               child: _buildConnectionError(),
    //             ),
    //           )
    //         : _news!.isEmpty && _topHeadlineViewModel.loadState == 'Loading'
    //             ? _buildLoading()
    //             : _news!.isNotEmpty &&
    //                     (_topHeadlineViewModel.loadState == 'Loaded' ||
    //                         _topHeadlineViewModel.loadState == 'Has More')
    //                 ? _buildHome(provider)
    //                 : Center(
    //                     child: Container(
    //                       color: Colors.transparent,
    //                       width: MediaQuery.of(context).size.width,
    //                       height: MediaQuery.of(context).size.height * 0.75,
    //                       child: _buildDataError(),
    //                     ),
    //                   );
  }

  //Top-Headline Page
  Widget _buildHome(ConnectionProvider provider) => ListView.builder(
        key: PageStorageKey('HomeList'),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _news!.length + 1,
        itemBuilder: (context, index) {
          if (index < _news!.length)
            return NewsCardWidget(
              id: '$index',
              model: _news![index],
            );
          else {
            if (_topHeadlineViewModel.loadState != 'Loaded') {
              if (provider.connectionState != ConnectivityResult.none) {
                if (_topHeadlineViewModel.loadState == 'Loading' &&
                    _topHeadlineViewModel.hasMore)
                  return const SizedBox(
                    height: 50,
                    child: const CustomCircularIndicator(
                      color: Colors.red,
                    ),
                  );
                else if (_topHeadlineViewModel.loadState == 'Error')
                  return _buildListEndError('Data');
              } else if (_topHeadlineViewModel.hasMore)
                return _buildListEndError('Connection');
            }
            return _topHeadlineViewModel.hasMore
                ? const SizedBox()
                : _buildListEndError('Connection');
          }
        },
      );

  //Loading
  Widget _buildLoading() {
    return Center(
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.75,
        child: const CustomCircularIndicator(
          color: Colors.red,
        ),
      ),
    );
  }

  //Connection Error
  Widget _buildConnectionError() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 115,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
          ),
          Text(
            'Check Your Internet Connection',
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
      );

  //Data Fetch Error
  Widget _buildDataError() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 125,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
          ),
          Text(
            'Somthing Went Wrong',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context)
                  .textTheme
                  .headline4!
                  .color!
                  .withOpacity(0.3),
            ),
          ),
        ],
      );

  //List End Errors
  Widget _buildListEndError(String errorType) => Center(
        child: Column(
          children: [
            Icon(
              errorType == 'Connection'
                  ? Icons.wifi_off_rounded
                  : Icons.warning_amber_rounded,
              size: 50,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
            ),
            Text(
              errorType == 'Connection'
                  ? 'Check Your Internet Connection'
                  : 'Somthing Went Wrong',
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
      );

  Future<bool> showRefresh() async {
    //homeViewModel.hasMore = true;
    if (!_loading) {
      _newsListController!.animateTo(
          _newsListController!.position.minScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
      refreshKey.currentState!.show();
    }
    return !_loading;
  }

  Future onRefresh() async {
    final int _categoriesIndex = Random().nextInt(_categories.length);
    _loading = true;
    //_topHeadlineViewModel.hasMore = false;
    _news!.clear();
    var _newNews = await _topHeadlineViewModel.getTopHeadLineNews(
        TopHeadLineNewsApi(),
        _news!.isNotEmpty ? _news!.indexOf(_news!.last) + 1 : 0,
        _country,
        _categories[_categoriesIndex]);
    //_news!.clear();
    setState(() {
      this._news = _newNews;
      _newsListController!
          .jumpTo(_newsListController!.position.minScrollExtent);
    });
    _loading = false;
  }
}
