import 'package:news_app/Model/Models/news_model.dart';
import 'package:news_app/Model/Repository/news_repository.dart';

class HomeViewModel {
  bool hasMore = true;
  Future<List<NewsModel>?> getTopHeadLineNews(
      TopHeadLineNewsRepository newsRepository,
      int index,
      String country,
      String _category) async {
    print('from ViewModel');
    final List _list = await newsRepository.getTopHeadLineNews(
        country: country, category: _category);
    hasMore = index + 6 < _list.length;
    return _list.isNotEmpty
        ? _list
            .getRange(index, hasMore ? index + 6 : _list.length)
            .map((model) => NewsModel.fromJson(model))
            .toList()
        : [];
  }
}
