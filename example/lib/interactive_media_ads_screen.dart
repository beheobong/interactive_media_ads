import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';
// #docregion imports
import 'package:video_player/video_player.dart';
// #enddocregion imports

// #docregion example_widget
/// Example widget displaying an Ad before a video.
class AdExampleWidget extends StatefulWidget {
  /// Constructs an [AdExampleWidget].
  const AdExampleWidget({Key key, @required this.adTagUrl}) : super(key: key);

  final String adTagUrl;

  @override
  State<AdExampleWidget> createState() => _AdExampleWidgetState();
}

class _AdExampleWidgetState extends State<AdExampleWidget> {
  // IMA sample tag for a single skippable inline video ad. See more IMA sample
  // tags at https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side/tags
  // static const String _adTagUrl =
  //     'https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=';

  // The AdsLoader instance exposes the request ads method.
  AdsLoader _adsLoader;

  // AdsManager exposes methods to control ad playback and listen to ad events.
  AdsManager _adsManager;

  // Whether the widget should be displaying the content video. The content
  // player is hidden while Ads are playing.
  bool _shouldShowContentVideo = true;

  // Controls the content video player.
  VideoPlayerController _contentVideoController;
  // #enddocregion example_widget

  // #docregion ad_and_content_players
  AdDisplayContainer _adDisplayContainer;

  @override
  void initState() {
    super.initState();
    _adDisplayContainer = AdDisplayContainer(
      onContainerAdded: (AdDisplayContainer container) {
        // Ads can't be requested until the `AdDisplayContainer` has been added to
        // the native View hierarchy.
        _requestAds(container);
      },
    );
    _contentVideoController = VideoPlayerController.network(
      'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
    )
      ..addListener(() {
        if (_contentVideoController.value.initialized) {
          _adsLoader.contentComplete();
          setState(() {});
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  // #enddocregion ad_and_content_players

  // #docregion request_ads
  Future<void> _requestAds(AdDisplayContainer container) {
    _adsLoader = AdsLoader(
      container: container,
      onAdsLoaded: (OnAdsLoadedData data) {
        final AdsManager manager = data.manager;
        _adsManager = data.manager;

        manager.setAdsManagerDelegate(AdsManagerDelegate(
          onAdEvent: (AdEvent event) {
            debugPrint('OnAdEvent: ${event.type}');
            switch (event.type) {
              case AdEventType.loaded:
                manager.start();
                break;
              case AdEventType.contentPauseRequested:
                _pauseContent();
                break;
              case AdEventType.contentResumeRequested:
                _resumeContent();
                break;
              case AdEventType.allAdsCompleted:
                manager.destroy();
                _adsManager = null;
                break;
              case AdEventType.clicked:
              case AdEventType.complete:
            }
          },
          onAdErrorEvent: (AdErrorEvent event) {
            debugPrint('AdErrorEvent: ${event.error.message}');
            _resumeContent();
          },
        ));

        manager.init();
      },
      onAdsLoadError: (AdsLoadErrorData data) {
        debugPrint('OnAdsLoadError: ${data.error.message}');
        _resumeContent();
      },
    );

    return _adsLoader.requestAds(AdsRequest(adTagUrl: widget.adTagUrl));
  }

  Future<void> _resumeContent() {
    setState(() {
      _shouldShowContentVideo = true;
    });
    return _contentVideoController.play();
  }

  Future<void> _pauseContent() {
    setState(() {
      _shouldShowContentVideo = false;
    });
    return _contentVideoController.pause();
  }
  // #enddocregion request_ads

  // #docregion dispose
  @override
  void dispose() {
    super.dispose();
    _contentVideoController.dispose();
    _adsManager?.destroy();
  }
  // #enddocregion dispose

  // #docregion example_widget
  // #docregion widget_build
  @override
  Widget build(BuildContext context) {
    // #enddocregion example_widget
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: 300,
          child: !_contentVideoController.value.initialized
              ? Container()
              : AspectRatio(
                  aspectRatio: _contentVideoController.value.aspectRatio,
                  child: Stack(
                    children: <Widget>[
                      // The display container must be on screen before any Ads can be
                      // loaded and can't be removed between ads. This handles clicks for
                      // ads.
                      _adDisplayContainer,
                      if (_shouldShowContentVideo)
                        VideoPlayer(_contentVideoController)
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton:
          _contentVideoController.value.initialized && _shouldShowContentVideo
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _contentVideoController.value.isPlaying
                          ? _contentVideoController.pause()
                          : _contentVideoController.play();
                    });
                  },
                  child: Icon(
                    _contentVideoController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                )
              : null,
    );
    // #docregion example_widget
  }
  // #enddocregion widget_build
}
// #enddocregion example_widget
