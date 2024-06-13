import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = MainScreenViewController()
        /*if CommandLine.arguments.contains("UITest_FailureAPI") {
            let mainScreen = MainScreen(cocktailsAPI: FakeCocktailsAPI(withFailure: .count(2)))
            window.rootViewController = UIHostingController(rootView: mainScreen)
        } else {
            window.rootViewController = UIHostingController(rootView: MainScreen())
        }*/
        window.rootViewController = UIHostingController(rootView: MainScreen())
        self.window = window
        window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {}
  func sceneDidBecomeActive(_ scene: UIScene) {}
  func sceneWillResignActive(_ scene: UIScene) {}
  func sceneWillEnterForeground(_ scene: UIScene) {}
  func sceneDidEnterBackground(_ scene: UIScene) {}
}

