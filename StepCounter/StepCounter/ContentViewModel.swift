import Foundation
import HealthKit

class ContentViewModel: ObservableObject {
    
    private let healthStore = HKHealthStore()

    @Published var dailyStepGoal: Double = 10000.0
    @Published var stepCount: Double = 0.0
    @Published var percent: Double = 0.0

    init() {
        requestAuthorization()
    }

    var absolutePercentageAngle: Double {
        RingShape.percentToAngle(percent: percent, startAngle: 0)
    }

    var relativePercentageAngle: Double {
        absolutePercentageAngle + Constants.startAngle
    }

    func requestAuthorization() {
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

    func startStepCountUpdates() {
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
            self.percent = min((self.stepCount / self.dailyStepGoal) * 100, 100)
        }
    }

}
