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
    if (loadState != 'Loaded') loadState = 'Loading';
    final List _list = await newsRepository.getTopHeadLineNews(
        country: country, category: _category);
    if (loadState != 'Loaded')
      loadState = _list.isEmpty
          ? 'Error'
          : index + 6 < _list.length
              ? 'Ok'
              : 'Loaded';
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
