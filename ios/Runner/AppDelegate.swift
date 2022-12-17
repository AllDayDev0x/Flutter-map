import UIKit
import Flutter
import GoogleMaps  // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: ADD SOMETHING
    GMSServices.provideAPIKey("AIzaSyDM6KllO-RjTQyp_u4DhZ933R29t4b5Azw")


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
