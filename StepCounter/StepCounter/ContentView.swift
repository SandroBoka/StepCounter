import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            Text("Steps: \(Int(viewModel.stepCount)) / \(Int(viewModel.dailyStepGoal))")
                .font(.title)
                .padding()

            GeometryReader { geometry in
                ZStack {
                    RingShape()
                        .stroke(style: StrokeStyle(lineWidth: Constants.lineWidth, lineCap: .round))
                        .fill(Constants.backgroundCircleColor)
                        .frame(width: Constants.width, height: Constants.height)

                    RingShape(drawnClockWise: false, percent: viewModel.percent, startAngle: Constants.startAngle)
                        .stroke(style: StrokeStyle(lineWidth: Constants.lineWidth, lineCap: .round))
                        .fill(Constants.focusedCircleColor)
                        .frame(width: Constants.width, height: Constants.height)

                    Circle()
                        .fill(Constants.focusedCircleColor)
                        .frame(width: Constants.lineWidth, height: Constants.lineWidth, alignment: .center)
                        .offset(x: self.getEndCirclelocation(frame: geometry.size).0,
                                y: self.getEndCirclelocation(frame: geometry.size).1)
                        .shadow(color: Constants.shadowColor, radius: Constants.shadowRadius,
                                x: getEndCircleShadowOffset().0,
                                y: getEndCircleShadowOffset().1)
                }
            }
            .padding(.vertical, 50)
            .padding(.horizontal, 50)
        }
    }

    private func getEndCirclelocation(frame: CGSize) -> (CGFloat, CGFloat) {
        let angleOfEndInRadians: Double = viewModel.relativePercentageAngle.toRadians()
        let offsetRadius = min(frame.width, frame.height) / 2

        return (offsetRadius * cos(angleOfEndInRadians).toCGFloat(),
                offsetRadius * sin(angleOfEndInRadians).toCGFloat())
    }

    private func getEndCircleShadowOffset() -> (CGFloat, CGFloat) {
        let angleForOffset = viewModel.absolutePercentageAngle + (Constants.startAngle + 90)
        let angleForOffsetInRadians = angleForOffset.toRadians()
        let relativeXOffset = cos(angleForOffsetInRadians)
        let relativeYOffset = sin(angleForOffsetInRadians)
        let xOffset = relativeXOffset.toCGFloat() * Constants.shadowOffsetMultiplier
        let yOffset = relativeYOffset.toCGFloat() * Constants.shadowOffsetMultiplier

        return (xOffset, yOffset)
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}

struct Constants {

    static let width = 300.0
    static let height = 300.0
    static let lineWidth = 40.0

    static let startAngle = -90.0

    static let shadowRadius: CGFloat = 5
    static let shadowOffsetMultiplier: CGFloat = shadowRadius + 2

    static let backgroundCircleColor = Color.green.opacity(0.4)
    static let focusedCircleColor = Color.green
    static let shadowColor = Color.black.opacity(0.2)

}

extension Double {

    func toRadians() -> Double {
        return self * Double.pi / 180
    }

    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }

}
