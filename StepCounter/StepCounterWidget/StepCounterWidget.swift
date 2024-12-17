import WidgetKit
import SwiftUI
import Steps

struct Provider: TimelineProvider {

    private let viewModel = WidgetViewModel(
        getColorUseCase: GetColorUseCase(stepsRepository: StepRepository()),
        setColorUseCase: SetColorUseCase(stepsRepository: StepRepository()),
        getDailyStepsUseCase: GetDailyStepsUseCase(stepsRepository: StepRepository()),
        setDailyStepsUseCase: SetDailyStepsUseCase(stepsRepository: StepRepository()))

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), viewModel: viewModel)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), viewModel: viewModel)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            viewModel.updateData()

            let entry = SimpleEntry(date: Date(), viewModel: viewModel)

            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 15),
                to: Date()
            )!

            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextUpdate)
            )

            completion(timeline)
        }
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let viewModel: WidgetViewModel
}

struct StepCounterWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack(spacing: 0) {
            if widgetFamily == .systemSmall {
                smallWidget
            } else if widgetFamily == .systemMedium {
                mediumWidget
            }
        }
        .foregroundStyle(.primaryForeground)
        .containerBackground(.widgetGray.gradient, for: .widget)
    }

    private var smallWidget: some View {
        VStack {
            Text("Steps")
                .fontWeight(.semibold)

            WidgetRingView(isSmall: true, viewModel: entry.viewModel)

            Text("\(Int(entry.viewModel.stepCount)) / \(Int(entry.viewModel.dailyStepGoal))")
                .font(.headline)
        }
    }

    private var mediumWidget: some View {
        HStack {
            WidgetRingView(isSmall: false, viewModel: entry.viewModel)
                .padding(.leading, 10)

            Spacer()

            Divider()
                .padding(.horizontal, 10)

            Spacer()

            VStack(spacing: 12) {
                Text("Steps")
                    .fontWeight(.semibold)

                Text("\(Int(entry.viewModel.stepCount)) / \(Int(entry.viewModel.dailyStepGoal))")
                    .font(.headline)

                Divider()

                Text("Move Goal")
                    .font(.headline)

                Text("\(Int(entry.viewModel.percent)) %")
                    .font(.headline)
            }
            .padding(.trailing, 10)
        }
    }

}

@main
struct StepCounterWidget: Widget {
    let kind: String = "StepCounterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                StepCounterWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                StepCounterWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }

}

struct StepCounterWidget_Previews: PreviewProvider {

    private static let viewModel = WidgetViewModel(
        getColorUseCase: GetColorUseCase(stepsRepository: StepRepository()),
        setColorUseCase: SetColorUseCase(stepsRepository: StepRepository()),
        getDailyStepsUseCase: GetDailyStepsUseCase(stepsRepository: StepRepository()),
        setDailyStepsUseCase: SetDailyStepsUseCase(stepsRepository: StepRepository()))

    static var previews: some View {
        StepCounterWidgetEntryView(
            entry: SimpleEntry(date: Date(), viewModel: viewModel))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }

}
