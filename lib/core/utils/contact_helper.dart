import 'package:url_launcher/url_launcher.dart';

class ContactHelper {
  ContactHelper._();

  static Future<bool> callPhone(String phoneNumber) async {
    final cleanedPhone = phoneNumber.trim();

    if (cleanedPhone.isEmpty) return false;

    final uri = Uri(scheme: 'tel', path: cleanedPhone);

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
