import 'package:flutter/material.dart';

class FutureWidget<T> extends StatefulWidget {
  const FutureWidget({
    super.key,
    required this.future,
    required this.widget,
  });

  final Future<T> Function() future;
  final Widget Function(T) widget;

  @override
  State<FutureWidget<T>> createState() => _FutureWidgetState<T>();
}

class _FutureWidgetState<T> extends State<FutureWidget<T>> {
  late Future<T> _future;

  void _getFuture() => setState(() {
        _future = widget.future();
      });

  Widget _error() => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error),
          IconButton(
              onPressed: _getFuture, icon: const Icon(Icons.replay_outlined))
        ],
      ));

  Widget _loading() => const Center(child: CircularProgressIndicator());

  Widget _widget(T data) {
    return widget.widget(data);
  }

  Widget _buildState(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (snapshot.hasError) return _error();
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData)
      return _widget(snapshot.data as T);
    return _loading();
  }

  @override
  void initState() {
    super.initState();
    _future = widget.future();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<T>(future: _future, builder: _buildState);
}
