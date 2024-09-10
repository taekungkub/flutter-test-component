import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'CounterProvider.g.dart';

@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;

  @override
  set state(int newState) => super.state = newState;
  int update(int Function(int state) cb) => state = cb(state);
}
