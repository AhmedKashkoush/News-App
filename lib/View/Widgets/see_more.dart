import 'package:flutter/material.dart';

class SeeMoreWidget extends StatefulWidget {
  final String? text;
  final int? textLength;
  final TextOverflow? overflow;
  const SeeMoreWidget(
      {Key? key,
      required this.text,
      required this.textLength,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  _SeeMoreWidgetState createState() => _SeeMoreWidgetState();
}

class _SeeMoreWidgetState extends State<SeeMoreWidget> {
  bool _isMore = false;
  String? _text;
  TextOverflow? _overflow;
  // int? _contentLines;
  // bool? _seeMoreShown;
  @override
  Widget build(BuildContext context) {
    if (widget.text != null) {
      final String? _trimmedText = widget.text!.substring(
          0,
          widget.text!.length > widget.textLength!
              ? widget.textLength
              : widget.text!.length);
      //final int? _contentLines = '\n'.allMatches(widget.text!).length + 1;
      _text = _isMore && _trimmedText!.length <= widget.text!.length
          ? widget.text!
          : '$_trimmedText...';
      // _overflow =
      //     _isMore && _lines == null ? TextOverflow.visible : widget.overflow;
      // _seeMoreShown = (!_isMore && _contentLines! > widget.linesCount!);
    } else {
      //_lines = 0;
      _overflow = TextOverflow.ellipsis;
      //_seeMoreShown = false;
    }
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _isMore = !_isMore;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _text!,
              maxLines: null,
              overflow: _overflow,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline4!.color,
                fontSize: 14,
              ),
            ),
            !_isMore && _text!.length < widget.text!.length
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isMore = !_isMore;
                          });
                        },
                        child: Text(
                          'See More',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .headline4!
                                .color!
                                .withOpacity(0.4),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
