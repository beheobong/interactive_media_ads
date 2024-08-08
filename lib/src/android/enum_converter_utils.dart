// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../platform_interface/platform_interface.dart';
import 'interactive_media_ads.g.dart' as ima;

/// Converts [ima.AdErrorType] to [AdErrorType].
AdErrorType toInterfaceErrorType(ima.AdErrorType type) {
  switch (type) {
    case ima.AdErrorType.load:
      return AdErrorType.loading;
    case ima.AdErrorType.play:
      return AdErrorType.playing;
    case ima.AdErrorType.unknown:
      return AdErrorType.unknown;
    default:
      return null;
  }
}

/// Attempts to convert an [ima.AdEventType] to [AdEventType].
///
/// Returns null is the type is not supported by the platform interface.
AdEventType toInterfaceEventType(ima.AdEventType type) {
  switch (type) {
    case ima.AdEventType.allAdsCompleted:
      return AdEventType.allAdsCompleted;
    case ima.AdEventType.completed:
      return AdEventType.complete;
    case ima.AdEventType.contentPauseRequested:
      return AdEventType.contentPauseRequested;
    case ima.AdEventType.contentResumeRequested:
      return AdEventType.contentResumeRequested;
    case ima.AdEventType.loaded:
      return AdEventType.loaded;
    case ima.AdEventType.clicked:
      return AdEventType.clicked;
    default:
      return null;
  }
}

/// Converts [ima.AdErrorCode] to [AdErrorCode].
AdErrorCode toInterfaceErrorCode(ima.AdErrorCode code) {
  switch (code) {
    case ima.AdErrorCode.adsPlayerWasNotProvided:
      return AdErrorCode.adsPlayerNotProvided;
    case ima.AdErrorCode.adsRequestNetworkError:
      return AdErrorCode.adsRequestNetworkError;
    case ima.AdErrorCode.companionAdLoadingFailed:
      return AdErrorCode.companionAdLoadingFailed;
    case ima.AdErrorCode.failedToRequestAds:
      return AdErrorCode.failedToRequestAds;
    case ima.AdErrorCode.internalError:
      return AdErrorCode.internalError;
    case ima.AdErrorCode.invalidArguments:
      return AdErrorCode.invalidArguments;
    case ima.AdErrorCode.overlayAdLoadingFailed:
      return AdErrorCode.overlayAdLoadingFailed;
    case ima.AdErrorCode.overlayAdPlayingFailed:
      return AdErrorCode.overlayAdPlayingFailed;
    case ima.AdErrorCode.playlistNoContentTracking:
      return AdErrorCode.playlistNoContentTracking;
    case ima.AdErrorCode.unexpectedAdsLoadedEvent:
      return AdErrorCode.unexpectedAdsLoadedEvent;
    case ima.AdErrorCode.unknownAdResponse:
      return AdErrorCode.unknownAdResponse;
    case ima.AdErrorCode.unknownError:
      return AdErrorCode.unknownError;
    case ima.AdErrorCode.vastAssetNotFound:
      return AdErrorCode.vastAssetNotFound;
    case ima.AdErrorCode.vastEmptyResponse:
      return AdErrorCode.vastEmptyResponse;
    case ima.AdErrorCode.vastLinearAssetMismatch:
      return AdErrorCode.vastLinearAssetMismatch;
    case ima.AdErrorCode.vastLoadTimeout:
      return AdErrorCode.vastLoadTimeout;
    case ima.AdErrorCode.vastMalformedResponse:
      return AdErrorCode.vastMalformedResponse;
    case ima.AdErrorCode.vastMediaLoadTimeout:
      return AdErrorCode.vastMediaLoadTimeout;
    case ima.AdErrorCode.vastNonlinearAssetMismatch:
      return AdErrorCode.vastNonlinearAssetMismatch;
    case ima.AdErrorCode.vastNoAdsAfterWrapper:
      return AdErrorCode.vastNoAdsAfterWrapper;
    case ima.AdErrorCode.vastTooManyRedirects:
      return AdErrorCode.vastTooManyRedirects;
    case ima.AdErrorCode.vastTraffickingError:
      return AdErrorCode.vastTraffickingError;
    case ima.AdErrorCode.videoPlayError:
      return AdErrorCode.videoPlayError;
    case ima.AdErrorCode.unknown:
      return AdErrorCode.unknownError;
    default:
      return null;
  }
}
