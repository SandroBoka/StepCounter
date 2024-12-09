import SwiftUI
import HealthKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
            _ scene: UIScene,
            willConnectTo session: UISceneSession,
            options connectionOptions: UIScene.ConnectionOptions
        ) {
            guard let windowScene = scene as? UIWindowScene else { return }

            let window = UIWindow(windowScene: windowScene)
            let contentViewModel = ContentViewModel()
            let contentView = ContentView(viewModel: contentViewModel)

            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }

}
