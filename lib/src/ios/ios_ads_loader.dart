// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../week.dart';
import '../platform_interface/platform_interface.dart';
import 'enum_converter_utils.dart';
import 'interactive_media_ads.g.dart';
import 'interactive_media_ads_proxy.dart';
import 'ios_ad_display_container.dart';
import 'ios_ads_manager.dart';

/// Implementation of [PlatformAdsLoaderCreationParams] for iOS.
class IOSAdsLoaderCreationParams extends PlatformAdsLoaderCreationParams {
  /// Constructs a [IOSAdsLoaderCreationParams].
  const IOSAdsLoaderCreationParams({
    @required PlatformAdDisplayContainer container,
    @required void Function(PlatformOnAdsLoadedData data) onAdsLoaded,
    @required void Function(AdsLoadErrorData data) onAdsLoadError,
    @visibleForTesting InteractiveMediaAdsProxy proxy,
  })  : _proxy = proxy ?? const InteractiveMediaAdsProxy(),
        super(
          container: container,
          onAdsLoaded: onAdsLoaded,
          onAdsLoadError: onAdsLoadError,
        );

  /// Creates a [IOSAdsLoaderCreationParams] from an instance of
  /// [PlatformAdsLoaderCreationParams].
  factory IOSAdsLoaderCreationParams.fromPlatformAdsLoaderCreationParams(
    PlatformAdsLoaderCreationParams params, {
    @visibleForTesting InteractiveMediaAdsProxy proxy,
  }) {
    return IOSAdsLoaderCreationParams(
      container: params.container,
      onAdsLoaded: params.onAdsLoaded,
      onAdsLoadError: params.onAdsLoadError,
      proxy: proxy,
    );
  }

  final InteractiveMediaAdsProxy _proxy;
}

/// Implementation of [PlatformAdsLoader] for iOS.
class IOSAdsLoader extends PlatformAdsLoader {
  /// Constructs an [IOSAdsLoader].
  IOSAdsLoader(PlatformAdsLoaderCreationParams params)
      : assert(params.container is IOSAdDisplayContainer),
        assert(
          (params.container as IOSAdDisplayContainer).adDisplayContainer !=
              null,
          'Ensure the AdDisplayContainer has been added to the Widget tree before creating an AdsLoader.',
        ),
        super.implementation(params) {
    _adsLoader = _iosParams._proxy.newIMAAdsLoader();
    _adsLoader.setDelegate(_delegate);
    _delegate = _createAdsLoaderDelegate(
      WeakReference<IOSAdsLoader>(this),
    );
    _iosParams = params is IOSAdsLoaderCreationParams
        ? params
        : IOSAdsLoaderCreationParams.fromPlatformAdsLoaderCreationParams(
            params);
  }

  IMAAdsLoader _adsLoader;
  IMAAdsLoaderDelegate _delegate;

  IOSAdsLoaderCreationParams _iosParams;

  @override
  Future<void> contentComplete() {
    return _adsLoader.contentComplete();
  }

  @override
  Future<void> requestAds(AdsRequest request) async {
    return _adsLoader.requestAds(_iosParams._proxy.newIMAAdsRequest(
      adTagUrl: request.adTagUrl,
      adDisplayContainer:
          (_iosParams.container as IOSAdDisplayContainer).adDisplayContainer,
    ));
  }

  // This value is created in a static method because the callback methods for
  // any wrapped classes must not reference the encapsulating object. This is to
  // prevent a circular reference that prevents garbage collection.
  static IMAAdsLoaderDelegate _createAdsLoaderDelegate(
    WeakReference<IOSAdsLoader> interfaceLoader,
  ) {
    return interfaceLoader.target._iosParams._proxy.newIMAAdsLoaderDelegate(
      adLoaderLoadedWith: (_, __, IMAAdsLoadedData adsLoadedData) {
        interfaceLoader.target?._iosParams?.onAdsLoaded(
          PlatformOnAdsLoadedData(
            manager: IOSAdsManager(adsLoadedData.adsManager),
          ),
        );
      },
      adsLoaderFailedWithErrorData: (_, __, IMAAdLoadingErrorData adErrorData) {
        interfaceLoader.target?._iosParams?.onAdsLoadError(
          AdsLoadErrorData(
            error: AdError(
              type: toInterfaceErrorType(adErrorData.adError.type),
              code: toInterfaceErrorCode(adErrorData.adError.code),
              message: adErrorData.adError.message,
            ),
          ),
        );
      },
    );
  }
}
