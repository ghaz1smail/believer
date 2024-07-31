import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class StaticFunctions {
  shareData(link) {
    Share.share(link);
  }

  urlLauncher(Uri uri) async {
    await launchUrl(uri);
  }
}
