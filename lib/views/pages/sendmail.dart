part of "pages.dart";

class Sendmail extends StatefulWidget {
  const Sendmail({Key? key}) : super(key: key);

  @override
  _SendmailState createState() => _SendmailState();
}

class _SendmailState extends State<Sendmail> {
  final _MailKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();

  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();
  bool _initialUriIsHandled = false;
  bool accept = false;

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('Uri : $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('Err : $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      print('Success, ');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('not initial uri');
        } else {
          accept = true;
          print('got initial uri : $uri');
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        print('Failed to get initial uri ');
      }
    }
  }

  @override
  void dispose() {
    ctrlEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (accept != true) {
      _handleInitialUri();

      return Scaffold(
        appBar: AppBar(
          title: Text("Send Mail to "),
        ),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            child: Form(
              key: _MailKey,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email", prefixIcon: Icon(Icons.email)),
                controller: ctrlEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return !EmailValidator.validate(value.toString())
                      ? 'The email is invalid!'
                      : null;
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_MailKey.currentState!.validate()) {
              await MailService()
                  .SendMail(ctrlEmail.text.toString())
                  .then((value) {
                var result = json.decode(value.body);
                print(result);
                Fluttertoast.showToast(msg: result['message'].toString());
              });
            }
          },
          child: Icon(Icons.send_rounded),
        ),
      );
    } else {
      return Congratulationpage();
    }
  }
}
