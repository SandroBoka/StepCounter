import Steps
import UIKit

protocol SceneDelegateDependenciesProtocol {

    var router: RouterProtocol { get }

}

protocol ViewModelFactoryProtocol {

    func makeHomeScreenViewModel() -> HomeScreenViewModel

}

class Dependencies : SceneDelegateDependenciesProtocol{

    private lazy var mainNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)

        return navigationController
    }()

    lazy var router: RouterProtocol = {
        Router(navigationController: mainNavigationController, viewModelFactory: self)
    }()

    lazy var stepRepository: StepRepositoryProtocol = {
        StepRepository()
    }()

    lazy var getColorUseCase: GetColorUseCaseProtocol = {
        GetColorUseCase(stepsRepository: stepRepository)
    }()

    lazy var setColorUseCase: SetColorUseCaseProtocol = {
        SetColorUseCase(stepsRepository: stepRepository)
    }()

    lazy var getDailyStepsUseCase: GetDailyStepsUseCaseProcotol = {
        GetDailyStepsUseCase(stepsRepository: stepRepository)
    }()

    lazy var setDailyStepsUseCase: SetDailyStepsUseCaseProtocol = {
        SetDailyStepsUseCase(stepsRepository: stepRepository)
    }()

}

extension Dependencies: ViewModelFactoryProtocol {

    func makeHomeScreenViewModel() -> HomeScreenViewModel {
        HomeScreenViewModel(
            getColorUseCase: getColorUseCase,
            setColorUseCase: setColorUseCase,
            getDailyStepsUseCase: getDailyStepsUseCase,
            setDailyStepsUseCase: setDailyStepsUseCase)
    }

}
