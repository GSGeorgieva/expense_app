part of project.entity;

class Collection<E> extends ListBase<E> {
  List<E> innerList = [];
  //
  // int? totalResults;
  //
  @override
  int get length => innerList.length;

  @override
  set length(int length) {
    innerList.length = length;
  }

  @override
  void operator []=(int index, E value) {
    innerList[index] = value;
  }

  @override
  E operator [](int index) => innerList[index];
//
// @override
// void add(E element) => innerList.add(element);
//
// @override
// void addAll(Iterable<E> iterable) => innerList.addAll(iterable);
//
// @override
// Iterable<T> map<T>(T Function(E e) f) => innerList.map(f);
}
