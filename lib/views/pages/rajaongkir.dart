part of 'pages.dart';

class RajaOngkir extends StatefulWidget {
  const RajaOngkir({super.key, required this.title});

  final String title;

  @override
  State<RajaOngkir> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RajaOngkir> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await RajaOngkirService.getOngkir().then((value) {
            var result = json.decode(value.body);
            print(result);
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
