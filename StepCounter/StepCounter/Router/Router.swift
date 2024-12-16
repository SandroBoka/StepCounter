import Steps
import SwiftUI

protocol RouterProtocol {

    func startIn(window: UIWindow)
    func showHomeScreen()

}

class Router: RouterProtocol {

    private let navigationController: UINavigationController
    private let viewModelFactory: ViewModelFactoryProtocol

    init(navigationController: UINavigationController, viewModelFactory: ViewModelFactoryProtocol) {
        self.navigationController = navigationController
        self.viewModelFactory = viewModelFactory
    }

    func startIn(window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showHomeScreen()
    }

    func showHomeScreen() {
        let viewModel = viewModelFactory.makeHomeScreenViewModel()
        let view = HomeScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
    }

}
