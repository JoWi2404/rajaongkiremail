part of 'pages.dart';

class Congratulationpage extends StatefulWidget {
  const Congratulationpage({Key? key}) : super(key: key);

  @override
  _CongratulationpageState createState() => _CongratulationpageState();
}

class _CongratulationpageState extends State<Congratulationpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Congratulations'),
      ),
      body: Center(
        child: Text('Cloud Computing task is completed!!'),
      ),
    );
  }
}
