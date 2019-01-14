import Flutter
import UIKit

public class SwiftFirebaseInvitePlugin: NSObject, FlutterPlugin, InviteDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
  	let flutterVC = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "flutter.testfairy.com/hello", binaryMessenger: flutterVC)
    let instance = SwiftFirebaseInvitePlugin()
    channel.setMethodCallHandler { [unowned self] (methodCall, result) in
	    guard let args = (methodCall.arguments as! [String: String]).first else { return }
	    self.sendInvite(call: call, args: args)
		}
  }

  public func sendInvite(_ call: FlutterMethodCall, args: [String: String]) {
  	let targetApplication = InvitesTargetApplication.init()
		targetApplication.androidClientID = self.androidClientIDLabel.text
  	if let invite = Invites.inviteDialog() {
	    invite.setInviteDelegate(self)

	    // NOTE: You must have the App Store ID set in your developer console project
	    // in order for invitations to successfully be sent.

	    // A message hint for the dialog. Note this manifests differently depending on the
	    // received invitation type. For example, in an email invite this appears as the subject.
	    invite.setMessage("Try this out!\n -\(GIDSignIn.sharedInstance().currentUser.profile.name)")
	    // Title for the dialog, this is what the user sees before sending the invites.
	    invite.setTitle("Invites Example")
	    invite.setDeepLink("app_url")
	    invite.setCallToActionText("Install!")
	    invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
	    invite.setOtherPlatformsTargetApplication(targetApplication)
	    invite.open()
	  }
  }

  func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
	  if let error = error {
	    print("Failed: " + error.localizedDescription)
	  } else {
	    print("\(invitationIds.count) invites sent")
	  }
	}
}
