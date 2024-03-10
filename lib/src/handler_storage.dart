class HandlerStorage<T> {
  T? _instance;
  Function? _factory;

  HandlerStorage.instance(this._instance);
  HandlerStorage.factory(this._factory);

  bool get isInstance => _instance != null;
  bool get isFactory => _factory != null;

  T resolve() {
    if (_factory != null) {
      return _factory!() as T;
    }
    return _instance!;
  }
}
