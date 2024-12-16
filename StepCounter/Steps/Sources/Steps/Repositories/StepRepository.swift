import Foundation

public protocol StepRepositoryProtocol {

    func setColor(color: String)
    func getColor() -> String
    func setDailySteps(steps: Double)
    func getDailySteps() -> Double

}

public class StepRepository: StepRepositoryProtocol {

    private let colorKey = "colorKey"
    private let dailyStepsKey = "dailyStepsKey"

    private let sharedDefaults = UserDefaults()

    public init() {}

    public func setColor(color: String) {
        sharedDefaults.set(color, forKey: colorKey)
    }

    public func getColor() -> String {
        guard let color = sharedDefaults.string(forKey: colorKey) else {
            setColor(color: "Green")
            return "Green"
        }

        return color
    }

    public func setDailySteps(steps: Double) {
        sharedDefaults.set(steps, forKey: dailyStepsKey)
    }

    public func getDailySteps() -> Double {
        let steps = sharedDefaults.double(forKey: dailyStepsKey)

        if steps == 0.0 {
            setDailySteps(steps: 8000.0)
            return 8000.0
        }

        return steps
    }

}
