import SwiftUI
import Steps

struct RingView: View {
    @ObservedObject var viewModel: HomeScreenViewModel

    private var showCircle: Bool {
        viewModel.triggerCircleUpdate
    }

    var body: some View {
        VStack {
            Text("Steps: \(Int(viewModel.stepCount)) / \(Int(viewModel.dailyStepGoal))")
                .font(.title)
                .padding()

            GeometryReader { geometry in
                ZStack {
                    RingShape()
                        .stroke(style: StrokeStyle(lineWidth: Constants.lineWidth, lineCap: .round))
                        .fill(AppColor.color(from: viewModel.selectedColor).opacity(0.4))
                        .frame(width: min(geometry.size.width, geometry.size.height),
                               height: min(geometry.size.width, geometry.size.height))

                    RingShape(drawnClockWise: false, percent: viewModel.percent, startAngle: Constants.startAngle)
                        .stroke(style: StrokeStyle(lineWidth: Constants.lineWidth, lineCap: .round))
                        .fill(AppColor.color(from: viewModel.selectedColor))
                        .frame(width: min(geometry.size.width, geometry.size.height),
                               height: min(geometry.size.width, geometry.size.height))
                        .animation(.bouncy(duration: 1), value: viewModel.percent)
                    

                    Circle()
                        .fill(AppColor.color(from: viewModel.selectedColor))
                        .frame(width: Constants.lineWidth, height: Constants.lineWidth, alignment: .center)
                        .offset(x: viewModel.getEndCirclelocation(frame: geometry.size).0,
                                y: viewModel.getEndCirclelocation(frame: geometry.size).1)
                        .shadow(color: Constants.shadowColor, radius: Constants.shadowRadius,
                                x: viewModel.getEndCircleShadowOffset().0,
                                y: viewModel.getEndCircleShadowOffset().1)
                        .opacity(showCircle ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6), value: showCircle)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(.vertical, 50)
            .padding(.horizontal, 50)
        }
    }

}

#Preview {
    RingView(viewModel: HomeScreenViewModel(
        getColorUseCase: GetColorUseCase(stepsRepository: StepRepository()),
        setColorUseCase: SetColorUseCase(stepsRepository: StepRepository()),
        getDailyStepsUseCase: GetDailyStepsUseCase(stepsRepository: StepRepository()),
        setDailyStepsUseCase: SetDailyStepsUseCase(stepsRepository: StepRepository())))
}
