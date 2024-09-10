import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'UserProvider.g.dart';

@riverpod
class User extends _$User {
  @override
  dynamic build() => {
        "userId": 1,
        "id": 1,
        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body":
            "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
      };

  @override
  set state(dynamic newState) => super.state = newState;
  dynamic update(dynamic Function(dynamic state) cb) => state = cb(state);

  void increment() => state++;
  void decrement() => state--;
}
