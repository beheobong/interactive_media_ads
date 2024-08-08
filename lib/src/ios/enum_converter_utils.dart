// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../platform_interface/platform_interface.dart';
import 'interactive_media_ads.g.dart' as ima;

/// Converts [ima.AdErrorType] to [AdErrorType].
AdErrorType toInterfaceErrorType(ima.AdErrorType type) {
   switch (type) {
    case ima.AdErrorType.loadingFailed : return AdErrorType.loading;
    case ima.AdErrorType.adPlayingFailed : return AdErrorType.playing;
    case ima.AdErrorType.unknown : return AdErrorType.unknown;
    default: return null;
  }
}

/// Attempts to convert an [ima.AdEventType] to [AdEventType].
///
/// Returns null is the type is not supported by the platform interface.
AdEventType toInterfaceEventType(ima.AdEventType type) {
   switch (type) {
    case ima.AdEventType.allAdsCompleted : return AdEventType.allAdsCompleted;
    case ima.AdEventType.completed : return AdEventType.complete;
    case ima.AdEventType.loaded : return AdEventType.loaded;
    case ima.AdEventType.clicked : return AdEventType.clicked;
    default: return null;
  }
}

/// Converts [ima.AdErrorCode] to [AdErrorCode].
AdErrorCode toInterfaceErrorCode(ima.AdErrorCode code) {
  switch (code) {
    case ima.AdErrorCode.companionAdLoadingFailed : return
       AdErrorCode.companionAdLoadingFailed;
    case ima.AdErrorCode.failedToRequestAds : return AdErrorCode.failedToRequestAds;
    case ima.AdErrorCode.invalidArguments : return AdErrorCode.invalidArguments;
    case ima.AdErrorCode.unknownError : return AdErrorCode.unknownError;
    case ima.AdErrorCode.vastAssetNotFound : return AdErrorCode.vastAssetNotFound;
    case ima.AdErrorCode.vastEmptyResponse : return AdErrorCode.vastEmptyResponse;
    case ima.AdErrorCode.vastLinearAssetMismatch : return
       AdErrorCode.vastLinearAssetMismatch;
    case ima.AdErrorCode.vastLoadTimeout : return AdErrorCode.vastLoadTimeout;
    case ima.AdErrorCode.vastMalformedResponse : return AdErrorCode.vastMalformedResponse;
    case ima.AdErrorCode.vastMediaLoadTimeout : return AdErrorCode.vastMediaLoadTimeout;
    case ima.AdErrorCode.vastTooManyRedirects : return AdErrorCode.vastTooManyRedirects;
    case ima.AdErrorCode.vastTraffickingError : return AdErrorCode.vastTraffickingError;
    case ima.AdErrorCode.videoPlayError : return AdErrorCode.videoPlayError;
    case ima.AdErrorCode.adslotNotVisible : return AdErrorCode.adslotNotVisible;
    case ima.AdErrorCode.apiError : return AdErrorCode.apiError;
    case ima.AdErrorCode.contentPlayheadMissing : return
       AdErrorCode.contentPlayheadMissing;
    case ima.AdErrorCode.failedLoadingAd : return AdErrorCode.failedLoadingAd;
    case ima.AdErrorCode.osRuntimeTooOld : return AdErrorCode.osRuntimeTooOld;
    case ima.AdErrorCode.playlistMalformedResponse : return
       AdErrorCode.playlistMalformedResponse;
    case ima.AdErrorCode.requiredListenersNotAdded : return
       AdErrorCode.requiredListenersNotAdded;
    case ima.AdErrorCode.streamInitializationFailed : return
       AdErrorCode.streamInitializationFailed;
    case ima.AdErrorCode.vastInvalidUrl : return AdErrorCode.vastInvalidUrl;
    case ima.AdErrorCode.videoElementUsed : return AdErrorCode.videoElementUsed;
    case ima.AdErrorCode.videoElement : return AdErrorCode.videoElement;
  }
}
