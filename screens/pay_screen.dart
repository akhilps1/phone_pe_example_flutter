import 'package:daddypro/phone_pe/pay/models/request_success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PayPage extends StatefulWidget {
  const PayPage({
    Key? key,
    required this.requestSuccess,
    required this.redirectUrl,
    required this.onStatusChanged,
  }) : super(key: key);
  final RequestSuccess requestSuccess;
  final String redirectUrl;
  final VoidCallback onStatusChanged;

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  double progress = 0;
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.tryParse(widget
                    .requestSuccess.data.instrumentResponse.redirectInfo.url),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              // ignore: no_leading_underscores_for_local_identifiers
              onUpdateVisitedHistory: (_, _url, androidIsReload) {
                String? url = _url.toString();

                if (mounted) {
                  if (url.contains(widget.redirectUrl)) {
                    widget.onStatusChanged();
                    Navigator.pop(context);
                  }
                }
              },
            ),
            if (progress < 1.0)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    bool? leavePage = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text("Confirm"),
          content: const Text("Do you want to leave the page?"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false); // Return false (not leaving)
              },
              child: const Text("Cancel"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Return true (leaving)
              },
              child: const Text("Leave"),
            ),
          ],
        );
      },
    );

    if (leavePage ?? false) {
      if (await _webViewController.canGoBack()) {
        _webViewController.goBack();
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }

    return false;
  }

  void _goBack() async {
    bool? leavePage = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text("Confirm"),
          content: const Text("Do you want to leave the page?"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false); // Return false (not leaving)
              },
              child: const Text("Cancel"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Return true (leaving)
              },
              child: const Text("Leave"),
            ),
          ],
        );
      },
    );

    if (leavePage ?? false) {
      if (await _webViewController.canGoBack()) {
        _webViewController.goBack();
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }
}
