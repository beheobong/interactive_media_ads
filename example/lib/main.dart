import 'package:flutter/material.dart';

import 'interactive_media_ads_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const AdExampleWidget(adTagUrl: "https://adnetwork-adserver.aiactiv.io/serve-bid-video/GJ0iPlJ5pfE4OJY3ce8cIisaiLvuH4zZUdXTXK3enXDPN8BA-jtifah4UQrX3gk-zuySFn5FDYel59ptX8ZC4vKseVYmmXUO22OVZqriCcEC3jHhurDa9nM30MwKdXcqJ1QnnDJNbg1KLPhdvWp2WL7uhZ2HtICBMF2yQqwf9a59QFj64qQUdFs3QGW3bMlVtyNWz3XWuMKzemLxRMVHJgWSXufpjgDANoJEKlZgZGvISHvZXKDn-V3ySc7AbZ555FSN9CJ94PNNlmQgwJodWThRrvtpS-YR1zzzVVcKvBYD8PcmJjZFe6trQL3CQbAosBl-eP7AQIzI_5Che0a-nDpdmdG_WVfN3DioWjwVKHwm9O75FwMCWhgd6RHyoHH_4ByAcwdz6BNggKWnqLm8kA-5NVAxvKBVNsZLjBbCwzKZR6xOSpn9FSuGtRC0qiK9fEC7S1mPWfcuz9fwWZIYZQeRzKOKkaXjM2vT_mtydRM_mFN0HiHroA_n5EzusyoOdF_fWGDAbnsGOKIDaq5BYZPwLiWdHqtjssaSu5DS6KZgspcKpOboalvhVjFsiXlm3yFCoIRh1_0-2mFKlp4au7zXZ6Hl_086cCM0125sCJnJ3qddP8pbiq7jiWzz7p053YeXlPBeXVFzRKZFQj6wyQ==.xml?rp={{AUCTION_PRICE}}&requestId={{REQUEST_ID}}&r=1068534183&uid=s%3A3d6b6f704e9fcea2a8345bcc51d7ba1c.%2BklM8g0biH%2FVcrvo4AurzWgkjVw0kzS8zmcERCTnLjs&skipDelay=0&vastversions[]=2&vastversions[]=3&vastversions[]=7",)
    },
  ));
}
