class SimpleDataUtils {
  static List<T> createData<T>(T createFactory(int index), {size = 10}) {
    List<T> lists = [];
    for (int i = 0; i < size; i++) {
      lists.add(createFactory(i));
    }
    return lists;
  }
}
