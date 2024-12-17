import Foundation
import HealthKit
import Steps
import SwiftUI

class WidgetViewModel: ObservableObject {

    private let healthStore = HKHealthStore()

    @Published var dailyStepGoal: Double
    @Published var stepCount: Double = 0.0
    @Published var percent: Double = 0.0
    @Published var selectedColor: String
    @Published var triggerCircleUpdate: Bool = false

    private let getColorUseCase: GetColorUseCaseProtocol
    private let setColorUseCase: SetColorUseCaseProtocol
    private let getDailyStepsUseCase: GetDailyStepsUseCaseProcotol
    private let setDailyStepsUseCase: SetDailyStepsUseCaseProtocol

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
    }

    func setColor() {
        setColorUseCase.setColor(color: selectedColor)
    }

    func setDailySteps() {
        setDailyStepsUseCase.setDailySteps(steps: dailyStepGoal)
        startStepCountUpdates()
    }

}

extension WidgetViewModel {

    private func requestAuthorization() {
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]

        healthStore.getRequestStatusForAuthorization(toShare: typesToShare, read: typesToRead) { (status, error) in
            if status == HKAuthorizationRequestStatus.unnecessary {
                self.startStepCountUpdates()
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func startStepCountUpdates() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }

        let date = Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date)
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)


        let query = HKAnchoredObjectQuery(
            type: stepCountType,
            predicate: predicate,
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

//extension WidgetViewModel {
//
//    var absolutePercentageAngle: Double {
//        RingShape.percentToAngle(percent: percent, startAngle: 0)
//    }
//
//    var relativePercentageAngle: Double {
//        absolutePercentageAngle + Constants.startAngle
//    }
//
//    func getEndCirclelocation(frame: CGSize) -> (CGFloat, CGFloat) {
//        let angleOfEndInRadians: Double = relativePercentageAngle.toRadians()
//        let offsetRadius = min(frame.width, frame.height) / 2
//
//        return (offsetRadius * cos(angleOfEndInRadians).toCGFloat(),
//                offsetRadius * sin(angleOfEndInRadians).toCGFloat())
//    }
//
//    func getEndCircleShadowOffset() -> (CGFloat, CGFloat) {
//        let angleForOffset = absolutePercentageAngle + (Constants.startAngle + 90)
//        let angleForOffsetInRadians = angleForOffset.toRadians()
//        let relativeXOffset = cos(angleForOffsetInRadians)
//        let relativeYOffset = sin(angleForOffsetInRadians)
//        let xOffset = relativeXOffset.toCGFloat() * Constants.shadowOffsetMultiplier
//        let yOffset = relativeYOffset.toCGFloat() * Constants.shadowOffsetMultiplier
//
//        return (xOffset, yOffset)
//    }
//
//}
