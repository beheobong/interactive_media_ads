// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

import '../../week.dart';
import '../platform_interface/platform_interface.dart';
import 'enum_converter_utils.dart';
import 'interactive_media_ads.g.dart' as ima;
import 'interactive_media_ads_proxy.dart';

/// Implementation of [PlatformAdsManagerDelegateCreationParams] for iOS.
class IOSAdsManagerDelegateCreationParams
    extends PlatformAdsManagerDelegateCreationParams {
  /// Constructs an [IOSAdsManagerDelegateCreationParams].
  const IOSAdsManagerDelegateCreationParams({
    void Function(AdEvent event) onAdEvent,
    void Function(AdErrorEvent event) onAdErrorEvent,
    @visibleForTesting InteractiveMediaAdsProxy proxy,
  })  : _proxy = proxy ?? const InteractiveMediaAdsProxy(),
        super(onAdEvent: onAdEvent, onAdErrorEvent:onAdErrorEvent);

  /// Creates an [IOSAdsManagerDelegateCreationParams] from an instance of
  /// [PlatformAdsManagerDelegateCreationParams].
  factory IOSAdsManagerDelegateCreationParams.fromPlatformAdsManagerDelegateCreationParams(
    PlatformAdsManagerDelegateCreationParams params, {
    @visibleForTesting InteractiveMediaAdsProxy proxy,
  }) {
    return IOSAdsManagerDelegateCreationParams(
      onAdEvent: params.onAdEvent,
      onAdErrorEvent: params.onAdErrorEvent,
      proxy: proxy,
    );
  }

  final InteractiveMediaAdsProxy _proxy;
}

/// Implementation of [PlatformAdsManagerDelegate] for iOS.
class IOSAdsManagerDelegate extends PlatformAdsManagerDelegate {
  /// Constructs an [IOSAdsManagerDelegate].
  IOSAdsManagerDelegate(PlatformAdsManagerDelegateCreationParams params) 
  : super.implementation(params){
    delegate = _createAdsManagerDelegate(
    WeakReference<IOSAdsManagerDelegate>(this),
  );
  _iosParams =
      params is IOSAdsManagerDelegateCreationParams
          ? params
          : IOSAdsManagerDelegateCreationParams
              .fromPlatformAdsManagerDelegateCreationParams(params);
  }

  /// The native iOS `IMAAdsManagerDelegate`.
  ///
  /// This handles ad events and errors that occur during ad or stream
  /// initialization and playback.
 
   ima.IMAAdsManagerDelegate delegate;

   IOSAdsManagerDelegateCreationParams _iosParams;

  // This value is created in a static method because the callback methods for
  // any wrapped classes must not reference the encapsulating object. This is to
  // prevent a circular reference that prevents garbage collection.
  static ima.IMAAdsManagerDelegate _createAdsManagerDelegate(
    WeakReference<IOSAdsManagerDelegate> interfaceDelegate,
  ) {
    return interfaceDelegate.target._iosParams._proxy.newIMAAdsManagerDelegate(
      didReceiveAdEvent: (_, __, ima.IMAAdEvent event) {
         final AdEventType eventType = toInterfaceEventType(event.type);
        if (eventType == null) {
          return;
        }

        interfaceDelegate.target?.params?.onAdEvent
            ?.call(AdEvent(type: eventType));
      },
      didReceiveAdError: (_, __, ima.IMAAdError event) {
        interfaceDelegate.target?.params?.onAdErrorEvent?.call(
          AdErrorEvent(
            error: AdError(
              type: toInterfaceErrorType(event.type),
              code: toInterfaceErrorCode(event.code),
              message: event.message,
            ),
          ),
        );
      },
      didRequestContentPause: (_, __) {
        interfaceDelegate.target?.params?.onAdEvent?.call(
          const AdEvent(type: AdEventType.contentPauseRequested),
        );
      },
      didRequestContentResume: (_, __) {
        interfaceDelegate.target?.params?.onAdEvent?.call(
          const AdEvent(type: AdEventType.contentResumeRequested),
        );
      },
    );
  }
}
