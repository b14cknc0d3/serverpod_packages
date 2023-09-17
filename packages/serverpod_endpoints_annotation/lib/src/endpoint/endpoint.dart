/// eg.
/// ```dart
/// class MovieAdminEndpoints extends Endpoint implements ModelAdmin<Session,Movie>
/// ```
abstract class BaseEndpoint<S, T> {
  ///create
  Future<void> create(S s, T row);

  ///read
  Future<T?> read(S s, int id);

  ///update
  Future<bool> update(S s, T row);

  ///delete
  Future<int> delete(S s, int id);

  ///getAll
  Future<List<T>> getAll(S s, {int limit = 20, int currentPage = 1});

  ///deleteAllSelected
  Future<int> deleteAllSelected(S s, Set<int> ids);

  ///search
  Future<List<T>> search(
    S s, {
    required Map<String, dynamic> queries,
    int limit = 20,
    int currentPage = 1,
  });
}
