import 'package:news_app/Model/Models/news_model.dart';
import 'package:news_app/Model/Repository/news_repository.dart';

class HomeViewModel {
  bool hasMore = true;
  bool hasError = false;
  String loadState = 'Loading';
  Future<List<NewsModel>?> getTopHeadLineNews(
      TopHeadLineNewsRepository newsRepository,
      int index,
      String country,
      String _category) async {
    print('from ViewModel');
    loadState = 'Loading';
    final List _list = await newsRepository.getTopHeadLineNews(
        country: country, category: _category);

    if (_list.isNotEmpty) {
      if (index + 6 < _list.length)
        loadState = 'Ok';
      else
        loadState = 'Loaded';
    } else {
      loadState = 'Error';
    }
    hasMore = index + 6 < _list.length;
    hasError = hasMore && _list.isEmpty;
    return _list.isNotEmpty
        ? _list
            .getRange(index, hasMore ? index + 6 : _list.length)
            .map((model) => NewsModel.fromJson(model))
            .toList()
        : [];
  }
}
