import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends Notifier {
  @override
  dynamic build() {
    return null;
  }

  @override
  set state(dynamic newState) => super.state = newState;
  dynamic update(dynamic Function(dynamic state) cb) => state = cb(state);
}

final userNotifierProvider = NotifierProvider<UserNotifier, dynamic>(() {
  return UserNotifier();
});
