import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveServiceScreen extends StatefulWidget {
  const LiveServiceScreen({super.key});

  @override
  State<LiveServiceScreen> createState() => _LiveServiceScreenState();
}

class _LiveServiceScreenState extends State<LiveServiceScreen> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;
  int _pageProgress = 0;
  static const String _liveServiceUrl =
      'https://ariseandshineministry.online.church';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _pageProgress = progress;
              isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              _pageProgress = 100;
            });
          },
          onHttpError: (HttpResponseError error) {
            setState(() {
              hasError = true;
            });
            // _showSnackBar('HTTP error: $error');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              hasError = true;
            });
            // _showSnackBar('Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_liveServiceUrl));
  }

  Future<void> _reloadPage() async {
    setState(() {
      hasError = false;
      isLoading = true;
      _pageProgress = 0;
    });
    await _controller.loadRequest(Uri.parse(_liveServiceUrl));
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 56, color: errorColor),
            const SizedBox(height: 16),
            Text(
              'Unable to load the live service right now.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Please check your internet connection or try again in a moment.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _reloadPage,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isLoading ? 1 : 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: Colors.black12,
                color: primaryColor,
                value: _pageProgress == 0 ? null : _pageProgress / 100,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyColor,
      // appBar: AppBar(
      //   title: const Text('Live Service'),
      //   centerTitle: true,
      //   backgroundColor: lightGreyColor,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: () {
      //         _controller.reload();
      //       },
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: hasError
                  ? _buildErrorState()
                  : AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isLoading ? 0 : 1,
                      child: WebViewWidget(controller: _controller),
                    ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !isLoading,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLoading ? 1 : 0,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            _buildProgressBar(),
          ],
        ),
      ),
      floatingActionButton: hasError
          ? FloatingActionButton(
              onPressed: _reloadPage,
              backgroundColor: primaryColor,
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }
}
