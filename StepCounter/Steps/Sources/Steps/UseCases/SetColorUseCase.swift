import Foundation

public protocol SetColorUseCaseProtocol {

    func setColor(color: String)

}

public class SetColorUseCase: SetColorUseCaseProtocol {

    private var stepsRepository: StepRepositoryProtocol

    public init(stepsRepository: StepRepositoryProtocol) {
        self.stepsRepository = stepsRepository
    }

    public func setColor(color: String) {
        stepsRepository.setColor(color: color)
    }

}
