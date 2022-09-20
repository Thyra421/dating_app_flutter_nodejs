import 'package:flutter/material.dart';

class FutureWidget extends StatefulWidget {
  const FutureWidget({
    super.key,
    required this.future,
    required this.widget,
  });

  final Future Function()? future;
  final Widget? widget;

  @override
  State<FutureWidget> createState() => _FutureWidgetState();
}

class _FutureWidgetState extends State<FutureWidget> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = widget.future!();
  }

  void _getFuture() => setState(() {
        _future = widget.future!();
      });

  Widget _buildState(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError)
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error),
          IconButton(
              onPressed: _getFuture, icon: const Icon(Icons.replay_outlined))
        ],
      ));
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData)
      return widget.widget!;
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder(future: _future, builder: _buildState);
}
