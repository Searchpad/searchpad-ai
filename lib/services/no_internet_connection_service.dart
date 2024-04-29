import 'dart:io'; //InternetAddress utility
import 'dart:async';
import 'package:booking_system_flutter/component/no_internet_connection_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart'; //For StreamController/Stream

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}

class ConnectionAwareWidget extends StatefulWidget {
  final Widget child;
  final ConnectionStatusSingleton connectionStatus;

  const ConnectionAwareWidget(
      {super.key, required this.child, required this.connectionStatus});

  @override
  _ConnectionAwareWidgetState createState() => _ConnectionAwareWidgetState();
}

bool hasConnection = true;

class _ConnectionAwareWidgetState extends State<ConnectionAwareWidget> {
  @override
  void initState() {
    initialInternetCheck();
    super.initState();
    widget.connectionStatus.connectionChange.listen((isConnected) {
      setState(() {
        hasConnection = isConnected;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  initialInternetCheck() async {
    hasConnection = await isNetworkAvailable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return hasConnection ? widget.child : const NoInternetScreen();
  }
}
