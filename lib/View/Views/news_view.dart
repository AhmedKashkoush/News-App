import 'package:flutter/material.dart';
import 'package:news_app/Model/Models/news_model.dart';
import 'package:news_app/View/Widgets/image_widgets.dart';
import 'package:news_app/View/Widgets/indicators.dart';
import 'package:news_app/View/Widgets/see_more.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  final String id;
  final NewsModel? model;

  const NewsScreen({Key? key, required this.model, required this.id})
      : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isMore = false;
  final int contentMaxLenght = 60;
  Widget _buildImage() {
    return CustomCachedNetworkImage(
      imageUrl: widget.model!.urlToImage,
    );
  }

  void _launchUrl(String url, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
              onWillPop: () async => Future.value(false),
              child: AlertDialog(
                content: Container(
                  height: 100,
                  child: const CustomCircularIndicator(
                    color: Colors.red,
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ));
    if (!await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false);
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline4!.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Failed To Launch Link',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline4!.color,
              fontSize: 18,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final int lines;
    // final TextOverflow overFlow;
    // final bool seeMoreShown;
    // int? contentLines;
    // if (widget.model!.content != null) {
    //   contentLines = '\n'.allMatches(widget.model!.content!).length;
    //   lines = isMore && contentLines > contentMaxLines
    //       ? contentLines
    //       : contentMaxLines;
    //   overFlow = isMore && contentLines > contentMaxLines
    //       ? TextOverflow.visible
    //       : TextOverflow.ellipsis;
    //   seeMoreShown = (!isMore && contentLines > contentMaxLines);
    // } else {
    //   lines = 0;
    //   overFlow = TextOverflow.ellipsis;
    //   seeMoreShown = false;
    // }
    return Hero(
      tag: widget.id,
      child: ScaffoldMessenger(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                //controller!.reverse();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: _buildImage(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model!.title!,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline4!.color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.model!.author != null &&
                              widget.model!.author!.isNotEmpty
                          ? Text(
                              'Author: ${widget.model!.author!}',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.model!.source != null &&
                              widget.model!.source!.isNotEmpty
                          ? Text(
                              'Source: ${widget.model!.source!["name"]}',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      widget.model!.publishedAt != null &&
                              widget.model!.publishedAt!.isNotEmpty
                          ? Text(
                              'Published At: ${widget.model!.publishedAt}',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      widget.model!.description != null &&
                              widget.model!.description!.isNotEmpty
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description:',
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SeeMoreWidget(
                                  text: widget.model!.description,
                                  textLength: contentMaxLenght,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 25,
                      ),
                      // widget.model!.content != null &&
                      //         widget.model!.content!.isNotEmpty
                      //     ? Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             'Content: ',
                      //             style: TextStyle(
                      //               color: Theme.of(context)
                      //                   .textTheme
                      //                   .headline4!
                      //                   .color,
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //           Expanded(
                      //             child: InkWell(
                      //               onTap: () {
                      //                 setState(() {
                      //                   isMore = !isMore;
                      //                 });
                      //               },
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     '${widget.model!.content}',
                      //                     maxLines: lines,
                      //                     overflow: overFlow,
                      //                     style: TextStyle(
                      //                       color: Theme.of(context)
                      //                           .textTheme
                      //                           .headline4!
                      //                           .color,
                      //                       fontSize: 14,
                      //                     ),
                      //                   ),
                      //                   seeMoreShown
                      //                       ? Row(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.end,
                      //                           children: [
                      //                             InkWell(
                      //                               onTap: () {
                      //                                 setState(() {
                      //                                   isMore = !isMore;
                      //                                 });
                      //                               },
                      //                               child: Text(
                      //                                 'See More',
                      //                                 overflow:
                      //                                     TextOverflow.ellipsis,
                      //                                 style: TextStyle(
                      //                                   color: Theme.of(context)
                      //                                       .textTheme
                      //                                       .headline4!
                      //                                       .color!
                      //                                       .withOpacity(0.4),
                      //                                   fontSize: 14,
                      //                                   fontWeight:
                      //                                       FontWeight.bold,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         )
                      //                       : const SizedBox(),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     : const SizedBox(),
                      const SizedBox(
                        height: 30,
                      ),
                      widget.model!.url != null && widget.model!.url!.isNotEmpty
                          ? Row(
                              children: [
                                Text(
                                  'Link To The News: ',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.blue.withOpacity(0.2),
                                    onTap: () {
                                      _launchUrl(widget.model!.url!, context);
                                    },
                                    child: Text(
                                      widget.model!.url!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
