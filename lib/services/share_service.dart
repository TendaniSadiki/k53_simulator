import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShareService {
  static Future<void> shareProgress(String sessionId, String userId) async {
    try {
      // Create static link with session ID
      final staticLink = 'https://k53simulator.com/results?session=$sessionId';
      
      // Share via WhatsApp
      await Share.share(
        'Check out my K53 test results! $staticLink',
        subject: 'My Driving Test Progress'
      );
      
      // Track share event
      await _trackShareEvent(sessionId, userId);
    } catch (e) {
      print('Share error: $e');
    }
  }

  static Future<void> _trackShareEvent(String sessionId, String userId) async {
    await FirebaseFirestore.instance.collection('share_events').add({
      'sessionId': sessionId,
      'userId': userId,
      'sharedAt': Timestamp.now(),
      'type': 'whatsapp',
    });
  }

  // Track when someone opens a shared link
  static Future<void> initDynamicLinks() async {
    // This method is no longer needed since we're using static links
    print('Dynamic links initialization is no longer required');
  }

  static Future<void> _trackLinkAccess(String sessionId) async {
    try {
      await FirebaseFirestore.instance.collection('link_access').add({
        'sessionId': sessionId,
        'accessedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Failed to track link access: $e');
      // Consider adding retry logic or error reporting here
    }
  }
}
