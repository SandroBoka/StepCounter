import SwiftUI

struct WidgetRingShape: Shape {

    private let drawnClockWise: Bool

    private var percent: Double
    private var startAngle: Double

    var animatableData: Double {
        get { percent }

        set { percent = newValue }
    }

    init(drawnClockWise: Bool = false, percent: Double = 100, startAngle: Double = -90) {
        self.drawnClockWise = drawnClockWise
        self.percent = percent
        self.startAngle = startAngle
    }

    static func percentToAngle(percent: Double, startAngle: Double) -> Double {
        (percent / 100 * 360) + startAngle
    }

    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius = min(width, height) / 2
        let center = CGPoint(x: width / 2, y: height / 2)
        let endAngle = Angle(
            degrees: WidgetRingShape.percentToAngle(
                percent: self.percent,
                startAngle: self.startAngle))

        return Path { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: Angle(degrees: self.startAngle),
                endAngle: endAngle,
                clockwise: self.drawnClockWise)
        }
    }

}
