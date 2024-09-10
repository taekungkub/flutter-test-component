import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll/providers/UserProvider2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnotherPage extends ConsumerStatefulWidget {
  const AnotherPage({super.key});

  @override
  ConsumerState<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends ConsumerState<AnotherPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another Page'),
      ),
      body: Center(
        child: Text('${user}'),
      ),
    );
  }
}
