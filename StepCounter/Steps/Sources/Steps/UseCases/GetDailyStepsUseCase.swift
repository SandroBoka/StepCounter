import Foundation

public protocol GetDailyStepsUseCaseProcotol {

    func getDailySteps() -> Double

}

public class GetDailyStepsUseCase: GetDailyStepsUseCaseProcotol {

    private let stepsRepository: StepRepositoryProtocol

    public init(stepsRepository: StepRepositoryProtocol) {
        self.stepsRepository = stepsRepository
    }

    public func getDailySteps() -> Double {
        stepsRepository.getDailySteps()
    }

}
