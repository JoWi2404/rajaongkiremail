part of 'services.dart';

class MailService {
  Future<http.Response> SendMail(email) {
    return http.post(
        Uri.https("joey.ngantokimt.com",
            "/cirestapi/cirestapi/api/mahasiswa/sendmail"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
        }));
  }
}
