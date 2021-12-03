import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Model/Models/news_model.dart';
import 'package:news_app/View/Views/news_view.dart';

import 'image_widgets.dart';

class NewsCardWidget extends StatelessWidget {
  final String id;
  final NewsModel model;
  const NewsCardWidget({Key? key, required this.model, required this.id})
      : super(key: key);

  // Widget _buildImage() {
  //   Widget _image;
  //   try {
  //     // _image = Image.network(
  //     //   model.urlToImage!,
  //     //   fit: BoxFit.cover,
  //     //   loadingBuilder: (context, child, loadingChunk) => loadingChunk != null
  //     //       ? Center(
  //     //           child: CircularProgressIndicator(
  //     //             value: loadingChunk.cumulativeBytesLoaded /
  //     //                 loadingChunk.expectedTotalBytes!,
  //     //             color: Colors.red,
  //     //             backgroundColor: Theme.of(context)
  //     //                 .textTheme
  //     //                 .headline4!
  //     //                 .color!
  //     //                 .withOpacity(0.3),
  //     //           ),
  //     //         )
  //     //       : SizedBox(), //child,
  //     //   errorBuilder: (context, error, trace) => Center(
  //     //     child: Text('$error'),
  //     //   ),
  //     // );
  //     _image = CachedNetworkImage(
  //       imageUrl: model.urlToImage!,
  //       fadeInDuration: const Duration(milliseconds: 300),
  //       fadeInCurve: Curves.easeInOut,
  //       // imageBuilder: (context, provider) => Image.network(
  //       //   model.urlToImage!,
  //       //   fit: BoxFit.cover,
  //       //   errorBuilder: (context, error, trace) => const Center(
  //       //     child: Icon(Icons.broken_image_rounded),
  //       //   ),
  //       // ),
  //       fit: BoxFit.cover,
  //       progressIndicatorBuilder: (context, url, progress) =>
  //           CustomCircularIndicator(
  //         color: Colors.red,
  //         backgroundColor:
  //             Theme.of(context).textTheme.headline4!.color!.withOpacity(0.3),
  //       ),
  //       errorWidget: (context, url, child) => Center(
  //         child: Icon(
  //           Icons.broken_image_rounded,
  //           size: 160,
  //           color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
  //         ),
  //       ),
  //     );
  //     // ignore: unnecessary_statements
  //   } catch (e) {
  //     _image = Builder(
  //       builder: (context) => Center(
  //         child: Icon(
  //           Icons.broken_image_rounded,
  //           size: 160,
  //           color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
  //         ),
  //       ),
  //     );
  //   }

  //   return _image;
  // }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(10),
        color: Theme.of(context).backgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CustomCachedNetworkImage(
                imageUrl: model.urlToImage,
              ),
              // model.urlToImage != null && model.urlToImage != ''
              //     ? Image.network(
              //         model.urlToImage!,
              //         fit: BoxFit.cover,
              //         loadingBuilder: (context, child, loadingChunk) =>
              //             loadingChunk != null
              //                 ? Center(
              //                     child: CircularProgressIndicator(
              //                       color: Colors.red,
              //                       backgroundColor: Theme.of(context)
              //                           .textTheme
              //                           .headline4!
              //                           .color!
              //                           .withOpacity(0.3),
              //                     ),
              //                   )
              //                 : child,
              //         errorBuilder: (context, child, trace) => const Center(
              //           child: Icon(Icons.broken_image_rounded),
              //         ),
              //       )
              //     : const Center(child: FaIcon(FontAwesomeIcons.image)),
              Positioned(
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      model.title!,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => NewsScreen(
                              model: this.model,
                              id: id,
                            )));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
