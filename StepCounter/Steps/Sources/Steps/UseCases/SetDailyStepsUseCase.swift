import Foundation

public protocol SetDailyStepsUseCaseProtocol {

    func setDailySteps(steps: Double)

}

public class SetDailyStepsUseCase: SetDailyStepsUseCaseProtocol {

    private let stepsRepository: StepRepositoryProtocol

    public init(stepsRepository: StepRepositoryProtocol) {
        self.stepsRepository = stepsRepository
    }

    public func setDailySteps(steps: Double) {
        stepsRepository.setDailySteps(steps: steps)
    }

}
