import SwiftUI
import Steps

struct WidgetRingView: View {
    let isSmall: Bool
    @ObservedObject var viewModel: WidgetViewModel

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    WidgetRingShape()
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: isSmall ? Constants.widgetLineWidth : Constants.widgetLineWidth + 5,
                                lineCap: .round))
                        .fill(AppColor.color(from: viewModel.selectedColor).opacity(0.3))
                        .frame(width: min(geometry.size.width, geometry.size.height),
                               height: min(geometry.size.width, geometry.size.height))

                    WidgetRingShape(drawnClockWise: false, percent: viewModel.percent, startAngle: Constants.startAngle)
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: isSmall ? Constants.widgetLineWidth : Constants.widgetLineWidth + 5,
                                lineCap: .round))
                        .fill(AppColor.color(from: viewModel.selectedColor))
                        .frame(width: min(geometry.size.width, geometry.size.height),
                               height: min(geometry.size.width, geometry.size.height))


                    Circle()
                        .fill(AppColor.color(from: viewModel.selectedColor))
                        .frame(
                            width: isSmall ? Constants.widgetLineWidth : Constants.widgetLineWidth + 5,
                            height: isSmall ? Constants.widgetLineWidth : Constants.widgetLineWidth + 5,
                            alignment: .center)
                        .offset(x: viewModel.getEndCirclelocation(frame: geometry.size).0,
                                y: viewModel.getEndCirclelocation(frame: geometry.size).1)
                        .shadow(color: Constants.shadowColor, radius: Constants.widgetShadowRadius,
                                x: viewModel.getEndCircleShadowOffset().0,
                                y: viewModel.getEndCircleShadowOffset().1)
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }

}
