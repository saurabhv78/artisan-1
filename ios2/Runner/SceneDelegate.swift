import UIKit
import FBSDKCoreKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }

    ApplicationDelegate.shared.application(
      UIApplication.shared,
      open: url,
      sourceApplication: nil,
      annotation: [UIApplication.OpenURLOptionsKey.annotation]
    )
  }
}
