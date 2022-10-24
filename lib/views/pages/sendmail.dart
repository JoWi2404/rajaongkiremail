part of "pages.dart";

class Sendmail extends StatefulWidget {
  const Sendmail({Key? key}) : super(key: key);

  @override
  _SendmailState createState() => _SendmailState();
}

class _SendmailState extends State<Sendmail> {
  final _MailKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();
  @override
  void dispose() {
    ctrlEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to  "),
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
              Fluttertoast.showToast(msg: result['message'].toString());
            });
          }
        },
        child: Icon(Icons.send_rounded),
      ),
    );
  }
}
