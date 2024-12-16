import Foundation

public protocol GetColorUseCaseProtocol {

    func getColor() -> String

}

public class GetColorUseCase: GetColorUseCaseProtocol {

    let stepsRepository: StepRepositoryProtocol

    public init(stepsRepository: StepRepositoryProtocol) {
        self.stepsRepository = stepsRepository
    }

    public func getColor() -> String {
        stepsRepository.getColor()
    }

}
