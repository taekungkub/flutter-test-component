import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll/providers/CounterProvider.dart';
import 'package:flutter_infinite_scroll/providers/UserProvider.dart';
import 'package:flutter_infinite_scroll/providers/UserProvider2.dart';
import 'package:flutter_infinite_scroll/screens/AnotherPage.dart';
import 'package:flutter_infinite_scroll/screens/MyWebView.dart';
import 'package:flutter_infinite_scroll/screens/RiverpodPage/RiverpodProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodPage extends ConsumerStatefulWidget {
  const RiverpodPage({super.key});

  @override
  ConsumerState<RiverpodPage> createState() => _RiverpodPageState();
}

class _RiverpodPageState extends ConsumerState<RiverpodPage> {
  Future onCreateData() async {
    final userData = await ref.read(userProvider);
    print(userData);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final productList = ref.watch(productProvider);
    final counterProvider = ref.watch(counterNotifierProvider);
    final user = ref.watch(userProvider);
    final user2 = ref.watch(userNotifierProvider);

    return Column(
      children: [
        ...productList.map((product) => Text(product.name)).toList(),
        ElevatedButton(
          onPressed: () {
            ref.read(counterNotifierProvider.notifier).update((state) => state + 1);
          },
          child: const Text('Increment'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(counterNotifierProvider.notifier).update((state) => state - 1);
          },
          child: const Text('Decrement'),
        ),
        Text('${counterProvider}'),
        ElevatedButton(
          onPressed: () {
            ref.read(userProvider.notifier).update((state) => {...state, 'title': 'new title'});
          },
          child: const Text('Update user'),
        ),
        ElevatedButton(
          onPressed: () {
            onCreateData();
          },
          child: const Text('Create user'),
        ),
        Text('${user['title']}'),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(userNotifierProvider.notifier).update((state) => {'title': 'new user2 title'});
          },
          child: const Text('Update user'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(userNotifierProvider.notifier).update((state) => null);
          },
          child: const Text('clear user'),
        ),
        Text('${user2?['title'] ?? '-'}'),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AnotherPage(),
              ),
            );
          },
          child: const Text('Go Another Page'),
        ),
      ],
    );
  }
}
