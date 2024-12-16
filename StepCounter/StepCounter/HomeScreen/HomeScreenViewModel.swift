import Foundation
import HealthKit
import Steps
import Combine

class HomeScreenViewModel: ObservableObject {
    
    private let healthStore = HKHealthStore()

    @Published var dailyStepGoal: Double
    @Published var stepCount: Double = 0.0
    @Published var percent: Double = 0.0
    @Published var selectedColor: String

    private let getColorUseCase: GetColorUseCaseProtocol
    private let setColorUseCase: SetColorUseCaseProtocol
    private let getDailyStepsUseCase: GetDailyStepsUseCaseProcotol
    private let setDailyStepsUseCase: SetDailyStepsUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()

    init(
        getColorUseCase: GetColorUseCaseProtocol,
        setColorUseCase: SetColorUseCaseProtocol,
        getDailyStepsUseCase: GetDailyStepsUseCaseProcotol,
        setDailyStepsUseCase: SetDailyStepsUseCaseProtocol
    ) {
        self.getColorUseCase = getColorUseCase
        self.setColorUseCase = setColorUseCase
        self.getDailyStepsUseCase = getDailyStepsUseCase
        self.setDailyStepsUseCase = setDailyStepsUseCase

        selectedColor = getColorUseCase.getColor()
        dailyStepGoal = getDailyStepsUseCase.getDailySteps()

        requestAuthorization()

        $dailyStepGoal
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self else { return }

                self.dailyStepGoal = value
                self.setDailySteps()
            }
            .store(in: &cancellables)
    }

    func setColor() {
        setColorUseCase.setColor(color: selectedColor)
    }

    func setDailySteps() {
        setDailyStepsUseCase.setDailySteps(steps: dailyStepGoal)
        startStepCountUpdates()
    }

}

extension HomeScreenViewModel {

    private func requestAuthorization() {
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if success {
                self.startStepCountUpdates()
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func startStepCountUpdates() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }

        let query = HKAnchoredObjectQuery(
            type: stepCountType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] (query, samples, deletedObjects, newAnchor, error) in
            self?.updateStepCount(from: samples)
        }

        query.updateHandler = { [weak self] (query, samples, deletedObjects, newAnchor, error) in
            self?.updateStepCount(from: samples)
        }

        healthStore.execute(query)
    }

    private func updateStepCount(from samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }

        DispatchQueue.main.async {
            self.stepCount = samples.reduce(0.0) { total, sample in
                total + sample.quantity.doubleValue(for: HKUnit.count())
            }
            self.percent = (self.stepCount / self.dailyStepGoal) * 100
        }
    }

}

extension HomeScreenViewModel {

    var absolutePercentageAngle: Double {
        RingShape.percentToAngle(percent: percent, startAngle: 0)
    }

    var relativePercentageAngle: Double {
        absolutePercentageAngle + Constants.startAngle
    }

    func getEndCirclelocation(frame: CGSize) -> (CGFloat, CGFloat) {
        let angleOfEndInRadians: Double = relativePercentageAngle.toRadians()
        let offsetRadius = min(frame.width, frame.height) / 2

        return (offsetRadius * cos(angleOfEndInRadians).toCGFloat(),
                offsetRadius * sin(angleOfEndInRadians).toCGFloat())
    }

    func getEndCircleShadowOffset() -> (CGFloat, CGFloat) {
        let angleForOffset = absolutePercentageAngle + (Constants.startAngle + 90)
        let angleForOffsetInRadians = angleForOffset.toRadians()
        let relativeXOffset = cos(angleForOffsetInRadians)
        let relativeYOffset = sin(angleForOffsetInRadians)
        let xOffset = relativeXOffset.toCGFloat() * Constants.shadowOffsetMultiplier
        let yOffset = relativeYOffset.toCGFloat() * Constants.shadowOffsetMultiplier

        return (xOffset, yOffset)
    }

}
