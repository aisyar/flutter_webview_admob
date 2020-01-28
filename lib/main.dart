import 'dart:io';

import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jurusanit/UI/WebPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(getAppId());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  //AdmobReward rewardAd;

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    // rewardAd = AdmobReward(
    //     adUnitId: getRewardBasedVideoAdUnitId(),
    //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //       if (event == AdmobAdEvent.closed) rewardAd.load();
    //       handleEvent(event, args, 'Reward');
    //     });

    interstitialAd.load();
    //rewardAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        //showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        //showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        //showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        //showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            key: scaffoldState,
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: WebviewScaffold(
                    url:"https://kuliah-jurusan-it.blogspot.com/", //"http://jurusanit.epizy.com/", //for http add AndroidManifest.xml <Application after @mipmap android:usesCleartextTraffic="true"
                    withJavascript: true,
                    withZoom: false,
                    hidden: true,
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      elevation: 1,
                      actions: <Widget>[
                        InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            size: 30.0,
                          ),
                          onTap: () async {
                            if (await interstitialAd.isLoaded) {
                              interstitialAd.show();
                            } else {
                              showSnackBar(
                                  "loading..."); //Interstitial ad is still loading
                            }
                            flutterWebviewPlugin.goBack();
                          },
                        ),
                        Spacer(),
                        InkWell(
                            child: Icon(
                              Icons.refresh,
                              size: 30.0,
                            ),
                            onTap: () async {
                              if (await interstitialAd.isLoaded) {
                                interstitialAd.show();
                              } else {
                                showSnackBar(
                                    "loading..."); //Interstitial ad is still loading
                              }
                              flutterWebviewPlugin.reload();
                              // flutterWebviewPlugin.reloadUrl("any link");
                            }),
                        Spacer(),
                        InkWell(
                          child: Icon(
                            Icons.arrow_forward,
                            size: 30.0,
                          ),
                          onTap: () async {
                            if (await interstitialAd.isLoaded) {
                              interstitialAd.show();
                            } else {
                              showSnackBar(
                                  "loading..."); //Interstitial ad is still loading
                            }
                            flutterWebviewPlugin.goForward();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50.0,
                    child: AdmobBanner(
                      adUnitId: getBannerAdUnitId(),
                      adSize: AdmobBannerSize.BANNER,
                      listener:
                          (AdmobAdEvent event, Map<String, dynamic> args) {
                        handleEvent(event, args, 'Banner');
                      },
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    //rewardAd.dispose();
    super.dispose();
  }
}

String getAppId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3494606031468782~2722353100'; //'ca-app-pub-3940256099942544~3347511713';
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3494606031468782/2530781411'; //'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3494606031468782/8904618076'; //'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}

// String getRewardBasedVideoAdUnitId() {
//   if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544/5224354917';
//   }
//   return null;
// }
