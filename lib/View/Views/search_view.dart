import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  final AnimationController? controller;
  const SearchScreen({Key? key, this.controller}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController? _searchController = TextEditingController();

  Widget _buildSearchText() {
    return Builder(
      builder: (context) => Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade700.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (s) {
                        setState(() {});
                      },
                      onSubmitted: (s) {
                        FocusScope.of(context).unfocus();
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      cursorHeight: 25,
                      controller: _searchController,
                      autofocus: true,
                      style: Theme.of(context).textTheme.headline4!,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .headline4!
                              .color!
                              .withOpacity(0.3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                  _searchController!.text.isNotEmpty
                      ? Transform.scale(
                          scale: 0.5,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _searchController!.clear();
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              size: 25,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Transform.scale(
            scale: 0.75,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                _searchController!.text.isNotEmpty ? Icons.search : Icons.mic,
                size: 30,
                color: Theme.of(context).iconTheme.color,
                // icon: FaIcon(
                //   _searchController!.text.isNotEmpty
                //       ? FontAwesomeIcons.search
                //       : FontAwesomeIcons.microphone,
                //   size: 30,
                //   color: Theme.of(context).iconTheme.color,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeListMethod('TextInput.hide');
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: _buildSearchText(),
          leading: BackButton(
            color: Theme.of(context).iconTheme.color,
            onPressed: () {
              //controller!.reverse();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
