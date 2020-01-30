import 'dart:io';

import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jurusanit/UI/WebPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(getAppId());
  runApp(MyHome());
}

class MyHome extends StatelessWidget {
  final MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: white),
    );
  }
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

  Future<bool> _onWillPop(FlutterWebviewPlugin fwp) {
    interstitialAd.show();
    fwp.hide();
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  fwp.show();
                },
                child: Text('No', style: TextStyle(color: Colors.black)),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes', style: TextStyle(color: Colors.black)),
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
      onWillPop: () => _onWillPop(flutterWebviewPlugin),
      child: Scaffold(
          key: scaffoldState,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: WebviewScaffold(
                  url: "https://kuliah-jurusan-it.blogspot.com/",
                  //"http://jurusanit.epizy.com/", //for http add AndroidManifest.xml <Application after @mipmap android:usesCleartextTraffic="true"
                  withJavascript: true,
                  withZoom: false,
                  hidden: true,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(40),
                    child: AppBar(
                      automaticallyImplyLeading: true,
                      elevation: 1,
                      actions: <Widget>[
                        InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            size: 35.0,
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
                              size: 35.0,
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
                            size: 35.0,
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
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50.0,
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: AdmobBannerSize.BANNER,
                    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                      handleEvent(event, args, 'Banner');
                    },
                  ),
                ),
              )
            ],
          )),
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
    return 'ca-app-pub-3494606031468782~2722353100';
    //return 'ca-app-pub-3940256099942544~3347511713'; //test
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3494606031468782/2530781411';
    //return 'ca-app-pub-3940256099942544/6300978111'; //test
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3494606031468782/8904618076';
    //return 'ca-app-pub-3940256099942544/1033173712'; //test
  }
  return null;
}

// String getRewardBasedVideoAdUnitId() {
//   if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544/5224354917';
//   }
//   return null;
// }
