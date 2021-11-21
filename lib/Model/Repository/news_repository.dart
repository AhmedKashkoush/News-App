abstract class NewsRepository {}

abstract class TopHeadLineNewsRepository extends NewsRepository {
  Future<List> getTopHeadLineNews(
      {required String? country, required String category});
}
