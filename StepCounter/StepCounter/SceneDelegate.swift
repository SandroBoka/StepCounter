import SwiftUI
import HealthKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var dependencies = Dependencies()

    func scene(
            _ scene: UIScene,
            willConnectTo session: UISceneSession,
            options connectionOptions: UIScene.ConnectionOptions
        ) {
            guard let windowScene = scene as? UIWindowScene else { return }

            window = UIWindow(windowScene: windowScene)
            guard let window else { return }

            dependencies.router.startIn(window: window)
        }

    func sceneDidEnterBackground(_ scene: UIScene) {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
